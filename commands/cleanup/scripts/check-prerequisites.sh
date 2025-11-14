#!/usr/bin/env bash
# Check prerequisites for cleanup commands
# Validates git repo, working tree, and test baseline

set -e

# Source truly common functions (print, file checks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate script directory is under HOME
if [[ -n "$HOME" ]] && [[ ! "$SCRIPT_DIR" =~ ^"$HOME"/.* ]]; then
    echo "ERROR: Script must be under HOME directory" >&2
    exit 1
fi

# Validate common.sh exists before sourcing
COMMON_SH="$SCRIPT_DIR/../../../scripts/common.sh"
if [[ ! -f "$COMMON_SH" ]]; then
    echo "ERROR: common.sh not found at $COMMON_SH" >&2
    exit 1
fi

source "$COMMON_SH"

# Parse options
JSON_MODE=false
SKIP_TESTS=false
TEST_CMD_OVERRIDE=""

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --skip-tests)
            SKIP_TESTS=true
            ;;
        --test-cmd=*)
            TEST_CMD_OVERRIDE="${arg#*=}"
            ;;
        --help|-h)
            cat << 'EOF'
Usage: check-prerequisites.sh [OPTIONS]

Check prerequisites for cleanup operations:
- Git repository exists
- Working tree is clean
- Tests are passing (baseline)

OPTIONS:
  --json              Output in JSON format
  --skip-tests        Skip test baseline check
  --test-cmd=CMD      Override test command detection
  --help, -h          Show this help message

OUTPUTS:
  JSON mode: {"status":"ok","test_cmd":"...","backup_branch":"..."}
  Text mode: TEST_CMD=... BACKUP_BRANCH=... (if all checks pass)

EXIT CODES:
  0 - All prerequisites met
  1 - Git repository check failed
  2 - Working tree has uncommitted changes
  3 - Tests failing

EXAMPLES:
  # Standard check
  ./check-prerequisites.sh

  # Check without running tests
  ./check-prerequisites.sh --skip-tests

  # Use custom test command
  ./check-prerequisites.sh --test-cmd="make test"
EOF
            exit 0
            ;;
        *)
            print_error "Unknown option '$arg'. Use --help for usage."
            exit 1
            ;;
    esac
done

# Get repository root
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        pwd
    fi
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_error "Not a git repository"
        echo ""
        echo "Initialize git first:"
        echo "  git init"
        echo "  git add ."
        echo "  git commit -m \"Initial commit\""
        return 1
    fi
    return 0
}

# Check for uncommitted changes
check_working_tree() {
    local status=$(git status --porcelain)
    if [ -n "$status" ]; then
        print_error "Uncommitted changes detected"
        echo ""
        echo "Either:"
        echo "1. Commit your changes:"
        echo "   git add ."
        echo "   git commit -m \"Your changes\""
        echo ""
        echo "2. Stash your changes:"
        echo "   git stash"
        return 1
    fi
    return 0
}

# Detect test command for the project
detect_test_command() {
    local test_cmd=""

    # Check package.json
    if [ -f "package.json" ] && grep -q '"test"' package.json; then
        # Check for specific package managers
        if [ -f "pnpm-lock.yaml" ]; then
            test_cmd="pnpm test"
        elif [ -f "yarn.lock" ]; then
            test_cmd="yarn test"
        else
            test_cmd="npm test"
        fi
    # Check for pytest
    elif command_exists pytest && find . -name "test_*.py" -o -name "*_test.py" 2>/dev/null | grep -q .; then
        test_cmd="pytest"
    # Check for cargo
    elif command_exists cargo && [ -f "Cargo.toml" ]; then
        test_cmd="cargo test"
    # Check for go
    elif command_exists go && [ -f "go.mod" ]; then
        test_cmd="go test ./..."
    # Check for make test
    elif [ -f "Makefile" ] && grep -q "^test:" Makefile; then
        test_cmd="make test"
    fi

    echo "$test_cmd"
}

# Run test command and establish baseline
establish_test_baseline() {
    local test_cmd="$1"
    local log_file="$2"

    if [ -z "$test_cmd" ]; then
        print_error "No test command provided"
        return 1
    fi

    print_info "Establishing test baseline..."
    print_info "Running: $test_cmd"

    # Execute test command with proper quoting
    if bash -c "$test_cmd" > "$log_file" 2>&1; then
        print_success "Test baseline established - all tests passing"
        return 0
    else
        print_error "Tests failing before operation"
        echo ""
        echo "Fix failing tests first:"
        echo "  $test_cmd"
        echo ""
        echo "View failures:"
        echo "  cat $log_file"
        return 1
    fi
}

# Create backup branch
create_backup_branch() {
    local prefix="$1"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local current_branch=$(git branch --show-current)
    local backup_branch="${prefix}-${timestamp}"

    # Check if branch already exists (shouldn't happen with timestamp, but be safe)
    if git rev-parse --verify "$backup_branch" >/dev/null 2>&1; then
        print_error "Backup branch '$backup_branch' already exists"
        return 1
    fi

    # Create backup branch
    if ! git checkout -b "$backup_branch" >/dev/null 2>&1; then
        print_error "Failed to create backup branch '$backup_branch'"
        return 1
    fi

    # Return to current branch
    if ! git checkout "$current_branch" >/dev/null 2>&1; then
        print_error "Failed to return to branch '$current_branch'"
        return 1
    fi

    echo "$backup_branch"
}

# Step 1: Check git repository
if ! check_git_repo; then
    if $JSON_MODE; then
        echo '{"error":"NOT_GIT_REPO","message":"Not a git repository"}'
    fi
    exit 1
fi

if $JSON_MODE; then
    print_info "✓ Git repository detected" >/dev/null
else
    print_success "Git repository detected"
fi

# Step 2: Check working tree
if ! check_working_tree; then
    if $JSON_MODE; then
        echo '{"error":"UNCOMMITTED_CHANGES","message":"Uncommitted changes detected"}'
    fi
    exit 2
fi

if $JSON_MODE; then
    print_info "✓ Working tree clean" >/dev/null
else
    print_success "Working tree clean"
fi

# Validate test command against whitelist
validate_test_command() {
    local cmd="$1"

    # Check for dangerous shell metacharacters
    if [[ "$cmd" =~ [\$\`\&\|\;\<\>\(\)\{\}] ]]; then
        return 1
    fi

    # Block path traversal attempts
    if [[ "$cmd" =~ \.\. ]]; then
        return 1
    fi

    # Whitelist of allowed test command patterns
    # Only allow alphanumeric, underscore, dash, dot, slash, colon, space
    if [[ "$cmd" =~ ^(npm|pnpm|yarn|pytest|cargo|go|make|mvn|gradle|php|ruby|rails|rake)([[:space:]][[:alnum:]_./:-]+)*$ ]] || \
       [[ "$cmd" =~ ^(npm|pnpm|yarn|pytest|cargo|make|mvn|gradle|php|ruby|rails|rake)$ ]]; then
        return 0
    fi
    return 1
}

# Step 3: Detect or use test command
if [ -n "$TEST_CMD_OVERRIDE" ]; then
    if ! validate_test_command "$TEST_CMD_OVERRIDE"; then
        print_error "Invalid test command: $TEST_CMD_OVERRIDE"
        echo ""
        echo "Test command must start with one of:"
        echo "  npm, pnpm, yarn, pytest, cargo, go, make, mvn, gradle, php, ruby, rails, rake"
        echo ""
        echo "Examples:"
        echo "  --test-cmd=\"npm test\""
        echo "  --test-cmd=\"pytest\""
        echo "  --test-cmd=\"cargo test\""
        exit 1
    fi
    TEST_CMD="$TEST_CMD_OVERRIDE"
else
    TEST_CMD=$(detect_test_command)
fi

if [ -z "$TEST_CMD" ] && [ "$SKIP_TESTS" = "false" ]; then
    if $JSON_MODE; then
        echo '{"error":"NO_TEST_CMD","message":"Cannot detect test command","prompt":"What command runs your tests?"}'
    else
        print_error "Cannot detect test command"
        echo ""
        echo "What command runs your tests?"
        echo ""
        echo "Examples:"
        echo "  - npm test"
        echo "  - pnpm test"
        echo "  - pytest"
        echo "  - cargo test"
        echo "  - go test ./..."
        echo "  - make test"
        echo ""
        echo "Re-run with: --test-cmd=\"your command\""
        echo "Or skip tests: --skip-tests"
    fi
    exit 3
fi

if [ -n "$TEST_CMD" ]; then
    if $JSON_MODE; then
        print_info "✓ Test command detected: $TEST_CMD" >/dev/null
    else
        print_success "Test command detected: $TEST_CMD"
    fi
fi

# Step 4: Establish test baseline (unless skipped)
LOG_FILE=$(mktemp -t cleanup-baseline-tests.XXXXXX)

if [ "$SKIP_TESTS" = "false" ] && [ -n "$TEST_CMD" ]; then
    if ! establish_test_baseline "$TEST_CMD" "$LOG_FILE"; then
        if $JSON_MODE; then
            echo '{"error":"TESTS_FAILING","message":"Tests failing before cleanup","log_file":"'$LOG_FILE'"}'
        fi
        exit 3
    fi
else
    if $JSON_MODE; then
        print_info "⊘ Tests skipped" >/dev/null
    else
        print_warning "Tests skipped"
    fi
fi

# Step 5: Create backup branch
BACKUP_BRANCH=$(create_backup_branch "backup/cleanup")

if $JSON_MODE; then
    print_info "✓ Backup branch created: $BACKUP_BRANCH" >/dev/null
else
    print_success "Backup branch created: $BACKUP_BRANCH"
fi

# Output results
if $JSON_MODE; then
    printf '{"status":"ok","test_cmd":"%s","backup_branch":"%s","log_file":"%s"}\n' \
        "$TEST_CMD" "$BACKUP_BRANCH" "$LOG_FILE"
else
    echo ""
    echo "TEST_CMD='$TEST_CMD'"
    echo "BACKUP_BRANCH='$BACKUP_BRANCH'"
    echo "LOG_FILE='$LOG_FILE'"
    echo ""
    print_success "All prerequisites met - ready for cleanup"
fi

exit 0
