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

## Additional Instructions

$ARGUMENTS

---

## Objective

Identify and remove dead code that clutters the codebase without affecting functionality.

### Categories

**Unused imports** - Modules imported but never referenced

**Unused functions** - Defined but never called, private methods with no references, exported with no external usage

**Unused variables** - Declared but never read, parameters never used, constants not referenced

**Commented code** - 5+ consecutive commented lines with code syntax (belongs in git history)

**Unreachable code** - After return/throw/break, conditional branches that never execute

**Unused files** - Source files with no imports, test files for deleted features, replaced implementations

---

## Execution

### Phase 0: Detection Strategy

**Run the tooling probe first** to know what's locally available:

```bash
"$CLAUDE_PLUGIN_ROOT/cleanup/scripts/probe-tooling.sh"
```

Then check your tool inventory for LSP MCP capabilities (`find_references`, `document_symbols`, `workspace_symbols`, `diagnostics`).

**Prefer LSP MCP when available.** References are authoritative, grep is not.

| Symptom | LSP signal | Linter fallback (from probe) | Grep fallback |
|---------|------------|------------------------------|---------------|
| Unused function/method | `find_references` returns 0 (or only the def site) | linter dead-code rule | `grep -rn "\bname\b"` excluding the def |
| Unused import | LSP `diagnostics` (`unused-import`) | `linters[lang]` (eslint, ruff, pyflakes, golangci-lint) with `--fix` | n/a |
| Unused export | `find_references` returns 0 external callers | n/a — linters are file-scoped | grep across repo (unreliable, misses dynamic) |
| Unused parameter | LSP diagnostic | linter | n/a |
| Unused file | `workspace_symbols` shows no callers | n/a | grep for filename / module path |

If neither LSP MCP nor linters are available, note in the audit that dynamic-dispatch languages have low confidence (eval, reflection, RPC tables, framework conventions like `on_*` handlers).

### Phase 1: Detect Dead Code

Scan codebase for unused code using the strategy chosen above. For each category:
- Report locations with context
- Verify findings (check for dynamic references, reflection, callbacks — LSP misses these too)
- Count impact (lines that can be removed)

**Be cautious with:**
- Public API exports - check for external usage first (LSP `find_references` is workspace-scoped; external consumers are invisible)
- Test utilities - may be needed later even if not currently used
- Code called dynamically (eval, reflection, event handlers, RPC dispatch tables, framework conventions like `on_*` handlers)

**Gate**: User must review findings before removal.

### Phase 2: Confirm Removals

Present findings to user with risk assessment:
```
Remove dead code?

□ Safe - Unused imports + variables (auto-fixable)
□ Low risk - Unused private functions + commented code
□ Needs review - Unused public functions + unused files
□ Custom - Select specific items
□ Cancel
```

**Gate**: Get user approval on which categories to remove.

### Phase 3: Execute Removals

For each approved category:

1. Remove items using language-specific tools when available (eslint --fix, autoflake). For functions/files, manual removal with careful validation.

2. Test and commit: Run `$TEST_CMD` after each category. If passing, commit. If failing, rollback and report which removal broke tests.

3. Continue safely: Process one category at a time. Stop on test failure.

**Gate**: Tests must pass before moving to next category.

### Phase 4: Report Results

Summarize: items removed per category, files affected, lines eliminated, code coverage maintained.

Delete the backup branch after successful completion:
```bash
git branch -D "$BACKUP_BRANCH"
```

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
