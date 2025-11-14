#!/usr/bin/env bash
# Find dev docs location
# Used by dev-docs commands to locate the dev docs directory

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../../scripts/common.sh"

# Parse options
JSON_MODE=false
TASK_NAME=""

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --task=*)
            TASK_NAME="${arg#*=}"
            ;;
        --help|-h)
            cat << 'EOF'
Usage: find-dev-docs.sh [OPTIONS]

Find dev docs directory location and validate structure.

OPTIONS:
  --json              Output in JSON format
  --task=NAME         Specify task name to validate
  --help, -h          Show this help message

OUTPUTS:
  JSON mode: {"DEV_DOCS_DIR":"...", "TASK_DIR":"...", "TASK_NAME":"..."}
  Text mode: DEV_DOCS_DIR=... TASK_DIR=... TASK_NAME=...

EXIT CODES:
  0 - Success
  1 - Dev docs directory not found
  2 - No active tasks found
  3 - Invalid task structure
EOF
            exit 0
            ;;
        *)
            print_error "Unknown option '$arg'. Use --help for usage."
            exit 1
            ;;
    esac
done

# Try to find dev docs directory
DEV_DOCS_DIR=""

# Option 1: Check project config
if [ -f ".claude/dev-docs-config" ]; then
    # Parse JSON config safely using jq
    if command -v jq &> /dev/null; then
        DEV_DOCS_DIR=$(jq -r '.devDocsPath // empty' .claude/dev-docs-config 2>/dev/null)
    else
        # Fallback: Python-based JSON parsing (safer than grep)
        DEV_DOCS_DIR=$(python3 -c "
import json, sys
try:
    with open('.claude/dev-docs-config') as f:
        data = json.load(f)
        print(data.get('devDocsPath', ''))
except:
    sys.exit(1)
" 2>/dev/null)
    fi

    # Verify directory exists
    if [ -n "$DEV_DOCS_DIR" ] && [ ! -d "$DEV_DOCS_DIR" ]; then
        DEV_DOCS_DIR=""
    fi
fi

# Option 2: Check common locations
if [ -z "$DEV_DOCS_DIR" ]; then
    if [ -d "$HOME/git/project/dev/active" ]; then
        DEV_DOCS_DIR="$HOME/git/project/dev/active"
    elif [ -d "./dev/active" ]; then
        DEV_DOCS_DIR="./dev/active"
    elif [ -d "./docs/dev" ]; then
        DEV_DOCS_DIR="./docs/dev"
    elif [ -d "./.dev-docs" ]; then
        DEV_DOCS_DIR="./.dev-docs"
    fi
fi

# If still not found, error
if [ -z "$DEV_DOCS_DIR" ] || [ ! -d "$DEV_DOCS_DIR" ]; then
    if $JSON_MODE; then
        echo '{"error":"DEV_DOCS_NOT_FOUND","message":"Cannot locate dev docs directory"}'
    else
        print_error "Cannot locate dev docs directory"
        echo ""
        echo "Expected one of:"
        echo "  - ~/git/project/dev/active/"
        echo "  - ./dev/active/"
        echo "  - ./docs/dev/"
        echo "  - ./.dev-docs/"
        echo ""
        echo "Run /shavakan-commands:dev-docs to create structure first."
    fi
    exit 1
fi

# If task name provided, validate it
if [ -n "$TASK_NAME" ]; then
    TASK_DIR="$DEV_DOCS_DIR/$TASK_NAME"

    if [ ! -d "$TASK_DIR" ]; then
        if $JSON_MODE; then
            echo "{\"error\":\"TASK_NOT_FOUND\",\"message\":\"Task directory not found: $TASK_NAME\"}"
        else
            print_error "Task directory not found: $TASK_NAME"
        fi
        exit 1
    fi

    # Validate task structure
    MISSING_FILES=()
    [ ! -f "$TASK_DIR/${TASK_NAME}-plan.md" ] && MISSING_FILES+=("${TASK_NAME}-plan.md")
    [ ! -f "$TASK_DIR/${TASK_NAME}-context.md" ] && MISSING_FILES+=("${TASK_NAME}-context.md")
    [ ! -f "$TASK_DIR/${TASK_NAME}-tasks.md" ] && MISSING_FILES+=("${TASK_NAME}-tasks.md")

    if [ ${#MISSING_FILES[@]} -gt 0 ]; then
        if $JSON_MODE; then
            printf '{"error":"INCOMPLETE_TASK","task_dir":"%s","missing_files":[' "$TASK_DIR"
            printf '"%s",' "${MISSING_FILES[@]}" | sed 's/,$//'
            echo ']}'
        else
            print_error "Task directory incomplete at $TASK_DIR"
            echo ""
            echo "Expected files:"
            echo "  - ${TASK_NAME}-plan.md"
            echo "  - ${TASK_NAME}-context.md"
            echo "  - ${TASK_NAME}-tasks.md"
            echo ""
            echo "Task may be corrupted. Regenerate with /shavakan-commands:dev-docs."
        fi
        exit 3
    fi
else
    # No specific task requested - find active tasks
    TASK_DIRS=($(find "$DEV_DOCS_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null))

    if [ ${#TASK_DIRS[@]} -eq 0 ]; then
        if $JSON_MODE; then
            echo '{"error":"NO_ACTIVE_TASKS","message":"No active tasks found"}'
        else
            print_error "No active tasks in $DEV_DOCS_DIR"
            echo ""
            echo "Run /shavakan-commands:dev-docs to create a task first."
        fi
        exit 2
    elif [ ${#TASK_DIRS[@]} -eq 1 ]; then
        # Exactly one task found
        TASK_DIR="${TASK_DIRS[0]}"
        TASK_NAME=$(basename "$TASK_DIR")
    else
        # Multiple tasks - need user selection
        if $JSON_MODE; then
            printf '{"error":"MULTIPLE_TASKS","dev_docs_dir":"%s","tasks":[' "$DEV_DOCS_DIR"
            for i in "${!TASK_DIRS[@]}"; do
                [ $i -gt 0 ] && echo -n ","
                printf '"%s"' "$(basename "${TASK_DIRS[$i]}")"
            done
            echo ']}'
        else
            print_error "Multiple active tasks found:"
            echo ""
            for i in "${!TASK_DIRS[@]}"; do
                echo "$((i+1)). $(basename "${TASK_DIRS[$i]}")"
            done
            echo ""
            echo "Re-run with --task=NAME to specify which task."
        fi
        exit 2
    fi
fi

# Output results
if $JSON_MODE; then
    printf '{"DEV_DOCS_DIR":"%s","TASK_DIR":"%s","TASK_NAME":"%s"}\n' \
        "$DEV_DOCS_DIR" "$TASK_DIR" "$TASK_NAME"
else
    echo "DEV_DOCS_DIR='$DEV_DOCS_DIR'"
    echo "TASK_DIR='$TASK_DIR'"
    echo "TASK_NAME='$TASK_NAME'"
    echo "PLAN_FILE='$TASK_DIR/${TASK_NAME}-plan.md'"
    echo "CONTEXT_FILE='$TASK_DIR/${TASK_NAME}-context.md'"
    echo "TASKS_FILE='$TASK_DIR/${TASK_NAME}-tasks.md'"
fi

exit 0
