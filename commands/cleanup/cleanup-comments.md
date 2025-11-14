---
description: Remove obvious comments, commented code, outdated TODOs - keep 'why' explanations
---

# Remove Comment Noise

Remove comments that add zero value. Code should be self-documenting. Keep comments that explain "why" not "what".

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before cleanup
3. Backup branch created automatically
4. Test validation after each change category

**Run prerequisite check:**

```bash
# Get the plugin root (where scripts are located)
PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/shavakan"

# Validate plugin root is under home directory
if [[ ! "$PLUGIN_ROOT" =~ ^"$HOME"/.* ]]; then
  echo "ERROR: Invalid plugin root path"
  exit 1
fi

# Run prerequisites check and source output
PREREQ_SCRIPT="$PLUGIN_ROOT/commands/cleanup/scripts/check-prerequisites.sh"
if [[ ! -f "$PREREQ_SCRIPT" ]]; then
  echo "ERROR: Prerequisites script not found at $PREREQ_SCRIPT"
  exit 1
fi

# Capture output to temp file and source it
PREREQ_OUTPUT=$(mktemp)
if "$PREREQ_SCRIPT" > "$PREREQ_OUTPUT" 2>&1; then
  source "$PREREQ_OUTPUT"
  rm "$PREREQ_OUTPUT"
else
  cat "$PREREQ_OUTPUT"
  rm "$PREREQ_OUTPUT"
  exit 1
fi
```

This exports: `TEST_CMD`, `BACKUP_BRANCH`, `LOG_FILE`

---

## Objective

Identify and remove comment noise across the codebase while preserving valuable "why" explanations.

### Remove These

**Obvious comments** - Repeat what code does ("increment counter" above `count++`)

**Commented code blocks** - 5+ consecutive commented lines with code syntax (belongs in git history)

**Outdated TODOs/FIXMEs** - >1 year old or already completed (check git blame)

**Redundant documentation** - JSDoc/docstrings that add no value beyond signature (`@param user The user`)

**Visual separators** - ASCII art, "end of section" markers (use file structure instead)

### Preserve These

**Non-obvious "why" explanations** - Why this approach vs alternatives

**Workarounds** - Performance trade-offs, security considerations, edge cases

**Hacks with justification** - Browser quirks, API limitations, temporary fixes with context

---

## Execution

### 1. Identify Comment Noise

Scan codebase for all five categories. For each finding, capture:
- Location (file:line or range)
- Comment content and surrounding code
- Why it's noise vs valuable

Present findings grouped by category with counts. Include examples of valuable comments you're preserving to demonstrate understanding.

Identify refactoring opportunities where improving code clarity (better names, extracted functions) would eliminate the need for explanatory comments.

### 2. Confirm Scope

Present findings to user. Ask which categories to remove based on their risk tolerance:
- **Safest**: Visual separators, obvious comments
- **Low risk**: Commented code blocks, redundant docs
- **Needs review**: Outdated TODOs (might still be relevant)

### 3. Execute Removals

For each approved category:

1. **Consider refactoring first**: If comment explains complex logic, can you make the code self-documenting instead?

2. **Remove comments**: Edit files safely. Process one category completely before starting next.

3. **Test and commit**: Run `$TEST_CMD` after each category. If tests pass, commit with message explaining what was removed. If tests fail, rollback and report which removal caused the issue.

4. **Continue or stop**: Proceed to next category only if tests pass.

### 4. Report Results

Summarize what was removed (counts per category), what was preserved, code improvements made, and impact (lines reduced, readability improved).

---

## Safety Constraints

**CRITICAL:**
- One category at a time with test validation between each
- Commit granularly - each category gets its own commit
- When in doubt, preserve the comment
- If comment explains complex code, refactor the code instead of removing comment
- Never remove comments that justify non-obvious technical decisions
- Test failure → rollback immediately, investigate before retrying

**If tests fail**: Rollback with `git checkout . && git clean -fd`, identify which specific removal broke tests, decide whether to skip that item or investigate further.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify changes don't introduce issues.

---

## Related Commands

- `/shavakan-commands:cleanup` - Full repository audit
- `/shavakan-commands:cleanup-dead-code` - Remove unused code
- `/shavakan-commands:cleanup-deps` - Clean dependencies
