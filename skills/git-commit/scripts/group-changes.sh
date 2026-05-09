#!/usr/bin/env bash
# Emit a baseline commit-grouping plan as JSON.
#
# Classifies changed files by deterministic signals (path/extension):
#   doc | config | test | types | code
# Source code (`code`) cannot be split into Fix/Feature/Refactor without
# semantic understanding — that's the LLM's job. This script provides the
# structural skeleton.
#
# Output schema:
#   {
#     "files":  [{"path","status","type","top"}, ...],
#     "groups": [{"id","type","top","files":[...]}, ...],
#     "order":  ["group_id_in_suggested_commit_order", ...]
#   }
#
# Usage:
#   group-changes.sh                # plan from working tree (staged + unstaged + untracked)
#   group-changes.sh --staged-only  # plan from staged changes only
#   group-changes.sh --vs=<ref>     # plan from diff vs ref (e.g. --vs=main)

set -euo pipefail

MODE="working"
DIFF_REF=""

for arg in "$@"; do
    case "$arg" in
        --staged-only) MODE="staged" ;;
        --vs=*)        MODE="ref"; DIFF_REF="${arg#*=}" ;;
        --help|-h)
            sed -n '2,21p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo '{"error":"NOT_GIT_REPO"}' >&2
    exit 1
fi

# Tempfile holds NUL-delimited "<status>\t<path>" records. Bash command
# substitution strips NULs, so we route through tempfiles instead.
TMP_RECORDS=$(mktemp)
trap 'rm -f "$TMP_RECORDS"' EXIT

case "$MODE" in
    staged)
        git diff --cached --name-status -z > "$TMP_RECORDS" 2>/dev/null || true
        ;;
    ref)
        if ! git rev-parse --verify "$DIFF_REF" >/dev/null 2>&1; then
            echo "{\"error\":\"BAD_REF\",\"ref\":\"$DIFF_REF\"}" >&2
            exit 1
        fi
        git diff --name-status -z "${DIFF_REF}...HEAD" > "$TMP_RECORDS" 2>/dev/null || true
        ;;
    working)
        git diff --cached --name-status -z >> "$TMP_RECORDS" 2>/dev/null || true
        git diff        --name-status -z >> "$TMP_RECORDS" 2>/dev/null || true
        # Untracked: emit two NUL-terminated fields per file (status then path),
        # matching `git diff --name-status -z` output shape.
        TMP_UNTRACKED=$(mktemp)
        git ls-files --others --exclude-standard -z > "$TMP_UNTRACKED" 2>/dev/null || true
        while IFS= read -r -d '' path; do
            [ -n "$path" ] || continue
            printf 'A\0%s\0' "$path" >> "$TMP_RECORDS"
        done < "$TMP_UNTRACKED"
        rm -f "$TMP_UNTRACKED"
        ;;
esac

# Path → type classification.
classify() {
    local p="$1"
    case "$p" in
        *test_*.py|*_test.py|*.test.ts|*.test.tsx|*.test.js|*.test.jsx|*.spec.ts|*.spec.js|*.spec.tsx|*.spec.jsx)
            echo "test"; return ;;
        *_test.go|*_test.rs)
            echo "test"; return ;;
        tests/*|test/*|*/tests/*|*/test/*|spec/*|*/spec/*|__tests__/*|*/__tests__/*)
            echo "test"; return ;;
        *.md|*.mdx|*.rst|*.txt|docs/*|*/docs/*|LICENSE|LICENSE.*|CHANGELOG|CHANGELOG.*|AUTHORS|CONTRIBUTING*)
            echo "doc"; return ;;
        package.json|package-lock.json|pnpm-lock.yaml|yarn.lock|Cargo.toml|Cargo.lock|go.mod|go.sum|requirements*.txt|pyproject.toml|poetry.lock|Pipfile|Pipfile.lock|Gemfile|Gemfile.lock|composer.json|composer.lock|build.gradle*|pom.xml|*.gemspec)
            echo "config"; return ;;
        .gitignore|.gitattributes|.editorconfig|.npmrc|.nvmrc|.tool-versions|.envrc|.envrc.example|.env.example|.dockerignore|Dockerfile|Dockerfile.*|docker-compose*.yml|docker-compose*.yaml|Makefile|*.mk|flake.nix|flake.lock|shell.nix|default.nix|.pre-commit-config.yaml|.eslintrc*|.prettierrc*|.stylelintrc*|tsconfig*.json|jest.config.*|vitest.config.*|webpack.config.*|rollup.config.*|vite.config.*|babel.config.*|.babelrc*|*.toml|*.yaml|*.yml|*.ini|*.cfg)
            echo "config"; return ;;
        .github/*|.gitlab/*|.circleci/*|.azure/*|.husky/*)
            echo "config"; return ;;
        *.d.ts|types/*|*/types/*|typings/*|*/typings/*)
            echo "types"; return ;;
        *)
            echo "code"; return ;;
    esac
}

top_segment() {
    local p="$1"
    case "$p" in
        */*) echo "${p%%/*}" ;;
        *)   echo "." ;;
    esac
}

# Lower rank = earlier commit.
order_rank() {
    case "$1" in
        types)  echo 0 ;;
        config) echo 1 ;;
        code)   echo 2 ;;
        test)   echo 3 ;;
        doc)    echo 4 ;;
        *)      echo 5 ;;
    esac
}

json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    printf '%s' "$s"
}

STATUSES=()
PATHS=()
TYPES=()
TOPS=()
declare -A SEEN_PATHS

# `git diff --name-status -z` emits NUL-separated fields: status, then path,
# (for R/C: status, old, new). State machine reads field by field.
state="status"
status=""
while IFS= read -r -d '' field; do
    case "$state" in
        status)
            status="$field"
            case "$status" in
                R*|C*) state="rename_old" ;;
                *)     state="path"       ;;
            esac
            ;;
        rename_old)
            # Discard old path; commit plan keys on destination.
            state="rename_new"
            ;;
        rename_new|path)
            path="$field"
            state="status"
            [ -n "$path" ] || continue

            if [ -n "${SEEN_PATHS[$path]:-}" ]; then
                continue
            fi
            SEEN_PATHS[$path]=1

            short="${status:0:1}"
            type=$(classify "$path")
            top=$(top_segment "$path")

            STATUSES+=("$short")
            PATHS+=("$path")
            TYPES+=("$type")
            TOPS+=("$top")
            ;;
    esac
done < "$TMP_RECORDS"

# Empty plan when nothing changed.
if [ "${#PATHS[@]}" -eq 0 ]; then
    printf '{"files":[],"groups":[],"order":[]}\n'
    exit 0
fi

# Group by "<type>|<top>".
declare -A GROUP_FILES
declare -A GROUP_SEEN
declare -a GROUP_KEYS
for i in "${!PATHS[@]}"; do
    key="${TYPES[$i]}|${TOPS[$i]}"
    if [ -z "${GROUP_SEEN[$key]:-}" ]; then
        GROUP_SEEN[$key]=1
        GROUP_KEYS+=("$key")
        GROUP_FILES[$key]=""
    fi
    GROUP_FILES[$key]+="${PATHS[$i]}"$'\n'
done

# Order groups: type rank, then top alphabetically.
TMP_ORDER=$(mktemp)
for key in "${GROUP_KEYS[@]}"; do
    type="${key%%|*}"
    top="${key#*|}"
    rank=$(order_rank "$type")
    printf '%s\t%s\t%s\n' "$rank" "$top" "$key"
done | sort -k1,1n -k2,2 | awk -F'\t' '{print $3}' > "$TMP_ORDER"

declare -a ORDERED_KEYS
while IFS= read -r key; do
    [ -n "$key" ] && ORDERED_KEYS+=("$key")
done < "$TMP_ORDER"
rm -f "$TMP_ORDER"

# Emit JSON.
{
    printf '{"files":['
    first=1
    for i in "${!PATHS[@]}"; do
        [ "$first" -eq 1 ] || printf ','
        first=0
        printf '{"path":"%s","status":"%s","type":"%s","top":"%s"}' \
            "$(json_escape "${PATHS[$i]}")" \
            "${STATUSES[$i]}" \
            "${TYPES[$i]}" \
            "$(json_escape "${TOPS[$i]}")"
    done
    printf '],"groups":['
    first=1
    for key in "${ORDERED_KEYS[@]}"; do
        [ "$first" -eq 1 ] || printf ','
        first=0
        type="${key%%|*}"
        top="${key#*|}"
        gid="${type}-$(echo "$top" | tr '/.' '__')"
        printf '{"id":"%s","type":"%s","top":"%s","files":[' \
            "$(json_escape "$gid")" \
            "$type" \
            "$(json_escape "$top")"
        files="${GROUP_FILES[$key]}"
        finner=1
        while IFS= read -r f; do
            [ -n "$f" ] || continue
            [ "$finner" -eq 1 ] || printf ','
            finner=0
            printf '"%s"' "$(json_escape "$f")"
        done <<<"$files"
        printf ']}'
    done
    printf '],"order":['
    first=1
    for key in "${ORDERED_KEYS[@]}"; do
        [ "$first" -eq 1 ] || printf ','
        first=0
        type="${key%%|*}"
        top="${key#*|}"
        gid="${type}-$(echo "$top" | tr '/.' '__')"
        printf '"%s"' "$(json_escape "$gid")"
    done
    printf ']}\n'
}
