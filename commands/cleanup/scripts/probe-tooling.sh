#!/usr/bin/env bash
# Probe local analysis tooling and emit a JSON capability matrix.
#
# Detects what's installed/configured for cleanup operations:
#   - Linters (per-language unused-detection)
#   - Structural analyzers (cycles, complexity, duplication)
#   - Type checkers
#   - Test runner
#
# What this script does NOT detect:
#   - LSP MCP server availability — that's exposed in the LLM's tool list,
#     not in the shell environment. The cleanup commands check that
#     separately and combine its result with this script's output.
#
# Output schema:
#   {
#     "languages":  ["typescript", "python", "go", ...],
#     "linters":    {"typescript": "eslint", "python": "ruff", ...},
#     "type_check": {"typescript": "tsc", "python": "mypy", ...},
#     "structural": ["madge", "dependency-cruiser", "jscpd"],
#     "complexity": ["lizard", "radon"],
#     "test_cmd":   "npm test"
#   }
#
# Missing tools are simply absent from the output (no false positives).

set -euo pipefail

JSON_PRETTY=false
for arg in "$@"; do
    case "$arg" in
        --pretty) JSON_PRETTY=true ;;
        --help|-h)
            sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

has() { command -v "$1" >/dev/null 2>&1; }
file_exists() { [ -f "$1" ]; }
glob_has() {
    # Returns 0 if any file matches the pattern in pwd (non-recursive).
    compgen -G "$1" >/dev/null 2>&1
}

# Detect languages by manifest presence.
LANGS=()
[ -f "package.json" ]      && LANGS+=("javascript")
file_exists "tsconfig.json" || glob_has "tsconfig*.json" \
                            && LANGS+=("typescript")
[ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ] \
                            && LANGS+=("python")
[ -f "go.mod" ]            && LANGS+=("go")
[ -f "Cargo.toml" ]        && LANGS+=("rust")
[ -f "Gemfile" ]           && LANGS+=("ruby")

# Dedupe LANGS.
declare -A LANG_SEEN
DEDUPED_LANGS=()
for l in "${LANGS[@]:-}"; do
    [ -n "$l" ] || continue
    if [ -z "${LANG_SEEN[$l]:-}" ]; then
        LANG_SEEN[$l]=1
        DEDUPED_LANGS+=("$l")
    fi
done
LANGS=("${DEDUPED_LANGS[@]:-}")

# Linters: prefer most-specific tool per language.
declare -A LINTERS
if [[ " ${LANGS[*]:-} " =~ " javascript " || " ${LANGS[*]:-} " =~ " typescript " ]]; then
    if has eslint || has npx; then
        # `npx eslint --version` confirms it's installable; skip if no config.
        if file_exists ".eslintrc" || file_exists ".eslintrc.json" || file_exists ".eslintrc.js" \
                                   || file_exists "eslint.config.js" || file_exists "eslint.config.mjs" \
                                   || file_exists "eslint.config.cjs"; then
            LINTERS[javascript]="eslint"
            [[ " ${LANGS[*]:-} " =~ " typescript " ]] && LINTERS[typescript]="eslint"
        fi
    fi
fi
if [[ " ${LANGS[*]:-} " =~ " python " ]]; then
    if has ruff;        then LINTERS[python]="ruff"
    elif has pyflakes;  then LINTERS[python]="pyflakes"
    elif has flake8;    then LINTERS[python]="flake8"
    fi
fi
if [[ " ${LANGS[*]:-} " =~ " go " ]]; then
    if has golangci-lint; then LINTERS[go]="golangci-lint"
    elif has staticcheck; then LINTERS[go]="staticcheck"
    elif has go;          then LINTERS[go]="go vet"
    fi
fi
if [[ " ${LANGS[*]:-} " =~ " rust " ]]; then
    has cargo && LINTERS[rust]="cargo clippy"
fi
if [[ " ${LANGS[*]:-} " =~ " ruby " ]]; then
    has rubocop && LINTERS[ruby]="rubocop"
fi

# Type checkers.
declare -A TYPECHK
if [[ " ${LANGS[*]:-} " =~ " typescript " ]]; then
    has tsc || has npx && TYPECHK[typescript]="tsc"
fi
if [[ " ${LANGS[*]:-} " =~ " python " ]]; then
    if has mypy;       then TYPECHK[python]="mypy"
    elif has pyright;  then TYPECHK[python]="pyright"
    elif has pyre;     then TYPECHK[python]="pyre"
    fi
fi

# Structural analyzers (deps, cycles, duplication).
STRUCTURAL=()
has madge              && STRUCTURAL+=("madge")
has dependency-cruiser && STRUCTURAL+=("dependency-cruiser")
has pydeps             && STRUCTURAL+=("pydeps")
has jscpd              && STRUCTURAL+=("jscpd")
has pmd                && STRUCTURAL+=("pmd")

# Complexity tools.
COMPLEXITY=()
has lizard && COMPLEXITY+=("lizard")
has radon  && COMPLEXITY+=("radon")
has gocyclo && COMPLEXITY+=("gocyclo")

# Test command (minimal heuristic — defer to check-prerequisites.sh for full detection).
TEST_CMD=""
if file_exists "package.json" && grep -q '"test"' package.json 2>/dev/null; then
    if file_exists "pnpm-lock.yaml"; then TEST_CMD="pnpm test"
    elif file_exists "yarn.lock";    then TEST_CMD="yarn test"
    else                                   TEST_CMD="npm test"
    fi
elif has pytest && (glob_has "test_*.py" || glob_has "*_test.py" || [ -d "tests" ]); then
    TEST_CMD="pytest"
elif has cargo && file_exists "Cargo.toml"; then
    TEST_CMD="cargo test"
elif has go && file_exists "go.mod"; then
    TEST_CMD="go test ./..."
elif file_exists "Makefile" && grep -q "^test:" Makefile 2>/dev/null; then
    TEST_CMD="make test"
fi

# JSON emit helpers.
json_str() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    printf '"%s"' "$s"
}
json_arr() {
    local items=("$@")
    local first=1 out="["
    for it in "${items[@]:-}"; do
        [ -n "$it" ] || continue
        [ "$first" -eq 1 ] || out+=","
        first=0
        out+=$(json_str "$it")
    done
    out+="]"
    printf '%s' "$out"
}
json_obj_from_assoc() {
    # $1 = nameref of assoc array
    local -n ref=$1
    local first=1 out="{"
    for k in "${!ref[@]}"; do
        [ "$first" -eq 1 ] || out+=","
        first=0
        out+=$(json_str "$k")
        out+=":"
        out+=$(json_str "${ref[$k]}")
    done
    out+="}"
    printf '%s' "$out"
}

OUT="{"
OUT+="\"languages\":$(json_arr "${LANGS[@]:-}"),"
OUT+="\"linters\":$(json_obj_from_assoc LINTERS),"
OUT+="\"type_check\":$(json_obj_from_assoc TYPECHK),"
OUT+="\"structural\":$(json_arr "${STRUCTURAL[@]:-}"),"
OUT+="\"complexity\":$(json_arr "${COMPLEXITY[@]:-}"),"
OUT+="\"test_cmd\":$(json_str "$TEST_CMD")"
OUT+="}"

if $JSON_PRETTY && has python3; then
    printf '%s' "$OUT" | python3 -m json.tool
else
    printf '%s\n' "$OUT"
fi
