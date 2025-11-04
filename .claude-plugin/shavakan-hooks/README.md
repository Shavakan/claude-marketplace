# shavakan-hooks

Personal hooks collection for Claude Code.

## Hooks

### PostToolUse: Ensure Final Newline

**Trigger**: After `Write`, `Edit`, or `MultiEdit` tool use

**Action**: Adds a final newline to files if missing (POSIX compliance)

**Implementation**: Shell command that checks file and appends newline if needed
