#!/usr/bin/env bash
# Common functions for all shavakan-commands
# Only truly shared utilities across dev-docs and cleanup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_error() { echo -e "${RED}ERROR: $1${NC}" >&2; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}WARNING: $1${NC}" >&2; }
print_info() { echo -e "${BLUE}$1${NC}"; }

# Check if command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Count lines in file
count_lines() {
    local file="$1"
    if [ -f "$file" ]; then
        wc -l < "$file" | tr -d ' '
    else
        echo "0"
    fi
}

# Check file exists (for display)
check_file() {
    local file="$1"
    local label="$2"
    if [ -f "$file" ]; then
        echo "  ✓ $label"
        return 0
    else
        echo "  ✗ $label"
        return 1
    fi
}

# Check directory exists and has files
check_dir() {
    local dir="$1"
    local label="$2"
    if [ -d "$dir" ] && [ -n "$(ls -A "$dir" 2>/dev/null)" ]; then
        echo "  ✓ $label"
        return 0
    else
        echo "  ✗ $label"
        return 1
    fi
}

# Export functions for use in other scripts
export -f print_error
export -f print_success
export -f print_warning
export -f print_info
export -f command_exists
export -f count_lines
export -f check_file
export -f check_dir
