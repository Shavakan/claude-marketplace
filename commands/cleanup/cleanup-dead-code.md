---
description: Remove unused imports, functions, variables, commented blocks, unreachable code
---

# Remove Dead Code

Find and safely remove unused code: imports, functions, variables, commented blocks, unreachable code, unused files.

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before cleanup
3. Backup branch created automatically
4. Test validation after each removal category

**Run prerequisite check:**

```bash
PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/shavakan"

if [[ ! "$PLUGIN_ROOT" =~ ^"$HOME"/.* ]]; then
  echo "ERROR: Invalid plugin root path"
  exit 1
fi

PREREQ_SCRIPT="$PLUGIN_ROOT/commands/cleanup/scripts/check-prerequisites.sh"
if [[ ! -f "$PREREQ_SCRIPT" ]]; then
  echo "ERROR: Prerequisites script not found"
  exit 1
fi

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

Identify and remove dead code that clutters the codebase without affecting functionality.

### Categories

**Unused imports** - Modules imported but never referenced (detect via linters: eslint, pylint, go vet)

**Unused functions** - Defined but never called, private methods with no references, exported with no external usage

**Unused variables** - Declared but never read, parameters never used, constants not referenced

**Commented code** - 5+ consecutive commented lines with code syntax (belongs in git history)

**Unreachable code** - After return/throw/break, conditional branches that never execute

**Unused files** - Source files with no imports, test files for deleted features, replaced implementations

---

## Execution

### 1. Detect Dead Code

Scan codebase for unused code using language-appropriate static analysis. For each category:
- Report locations with context
- Verify findings (check for dynamic references, reflection, callbacks)
- Count impact (lines that can be removed)

**Be cautious with:**
- Public API exports - check for external usage first
- Test utilities - may be needed later even if not currently used
- Code called dynamically (eval, reflection, event handlers)

### 2. Confirm Removals

Present findings to user with risk assessment:
- **Safe**: Unused imports, unused variables (auto-fixable)
- **Low risk**: Unused private functions, commented code
- **Needs review**: Unused public functions, unused files

### 3. Execute Removals

For each approved category:

1. **Remove items**: Use language-specific tools when available (eslint --fix, autoflake). For functions/files, manual removal with careful validation.

2. **Test and commit**: Run `$TEST_CMD` after each category. If passing, commit. If failing, rollback and report which removal broke tests.

3. **Continue safely**: Process one category at a time. Stop on test failure.

### 4. Report Results

Summarize: items removed per category, files affected, lines eliminated, code coverage maintained.

---

## Safety Constraints

**CRITICAL:**
- One category at a time with test validation
- Never remove public API exports without confirming no external usage
- Verify zero references using code search before removing
- Test after each removal - rollback on failure
- Commit granularly
- Use `git rm` for file removal to preserve history
- Check for dynamic references (code may be called via string identifiers)

**If tests fail**: Rollback, identify which specific removal caused failure, decide whether to skip that item or investigate why it was actually needed.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify removals don't introduce issues.

---

## Related Commands

- `/shavakan-commands:cleanup` - Full repository audit
- `/shavakan-commands:cleanup-comments` - Clean up comments
- `/shavakan-commands:cleanup-architecture` - Refactor structure
