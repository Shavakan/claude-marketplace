---
description: Comprehensive repository audit and cleanup (dead code, comments, docs, architecture, deps)
---

# Repository Cleanup Audit

Scan the codebase for cleanup opportunities across all categories. Generate comprehensive report, then execute improvements based on user priorities.

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before cleanup
3. Backup branch created automatically
4. Test validation after each cleanup operation

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

Perform comprehensive audit of codebase for cleanup opportunities across all categories, then execute selected improvements systematically.

### Cleanup Categories

1. **Dead Code** - Unused imports, functions, variables, files
2. **Comments** - Obvious comments, commented code, outdated TODOs
3. **Documentation** - Broken links, outdated docs, missing API docs
4. **Architecture** - God objects, circular deps, poor separation
5. **Dependencies** - Unused packages, vulnerabilities, outdated deps
6. **Duplication** - Repeated code, magic values, similar patterns

---

## Execution

### Phase 1: Comprehensive Scan

Scan entire codebase for cleanup opportunities across all categories. For each category, identify issues with location, severity, and estimated impact.

Present audit findings grouped by category with counts. Include priority assessment:
- **Critical**: Security vulnerabilities, god objects blocking development, circular dependencies causing bugs
- **High**: Dead code cluttering codebase, broken documentation, architecture issues
- **Medium**: Comment noise, code duplication, outdated dependencies (non-security)

**Gate**: User must review full audit before proceeding.

### Phase 2: Prioritize with User

Present cleanup options with impact assessment:
```
Execute cleanup operations?

□ Critical only - Security fixes + blocking issues
□ Safe cleanups - Dead code + unused imports + obvious comments
□ Structural - Architecture + dead code + duplication
□ Full cleanup - All categories (comprehensive)
□ Custom - Select specific categories
□ Cancel
```

**Gate**: Get user approval on which categories to clean.

### Phase 3: Execute Cleanups

**IMPORTANT**: This command orchestrates by invoking specialized subcommands. Do not implement cleanup logic directly - use the subcommands:

- Security/unused/outdated deps → invoke `/shavakan-commands:cleanup-deps`
- Architecture issues → invoke `/shavakan-commands:cleanup-architecture`
- Dead code → invoke `/shavakan-commands:cleanup-dead-code`
- Comments → invoke `/shavakan-commands:cleanup-comments`
- Duplication → invoke `/shavakan-commands:cleanup-duplication`
- Documentation → invoke `/shavakan-commands:cleanup-docs`

**Execution order**: Security first, then structural improvements, then code quality, then documentation/maintenance.

**Between each subcommand**: Verify tests pass. If passing, proceed to next. If failing, rollback and report issue. User can cancel at any point.

**Gate**: Tests must pass after each subcommand before proceeding.

### Phase 4: Report Results

Summarize metrics (lines reduced, files removed, issues resolved), what was cleaned (by category with counts), impact analysis (code coverage maintained, build size reduced, maintainability improved).

Delete the backup branch after successful completion:
```bash
git branch -D "$BACKUP_BRANCH"
```

Note: All commits granular and revertable.

---

## Auto-Fix Mode

For safe automated fixes, execute:
- Remove unused imports (linter auto-fix)
- Remove obvious comments (unambiguous patterns only)
- Fix dead internal links (update to new file locations)
- Extract magic strings to constants (3+ occurrences)

Each fix tested independently. Rollback on any test failure. Commit each fix type separately.

---

## Safety Constraints

**CRITICAL:**
- One category at a time - complete and test each before next
- Security first - fix critical vulnerabilities before cosmetic changes
- Test continuously - run tests after each category
- Commit granularly - each fix gets its own commit
- Preserve rollback - keep backup branch until changes verified
- User confirmation - ask before executing each major change
- Stop on failure - don't continue if tests fail

**Error handling**: If cleanup fails, report which categories completed successfully (with commits), which category failed (with error), and offer options: skip failed category and continue, stop to investigate, or rollback all changes.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify all changes.

**Final verification**: Run full test suite, check build succeeds, review commits, update CHANGELOG if significant changes.

---

## Related Commands

- `/shavakan-commands:cleanup-dead-code` - Remove unused code
- `/shavakan-commands:cleanup-deps` - Manage dependencies
- `/shavakan-commands:cleanup-comments` - Clean up comments
- `/shavakan-commands:cleanup-docs` - Fix documentation
- `/shavakan-commands:cleanup-architecture` - Refactor structure
- `/shavakan-commands:cleanup-duplication` - Remove duplication
