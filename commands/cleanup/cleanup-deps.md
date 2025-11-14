---
description: Clean dependencies - remove unused, fix security issues, update outdated, deduplicate
---

# Clean Up Dependencies

Remove unused packages, fix security vulnerabilities, update outdated packages, eliminate duplicate versions.

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before cleanup
3. Backup branch created automatically
4. Test validation after each dependency change

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

Clean up project dependencies across four categories:

**Unused dependencies** - Installed but never imported, dev deps not used in build/test

**Security vulnerabilities** - Packages with known CVEs (critical/high priority)

**Outdated dependencies** - Packages with newer stable versions, major updates available

**Duplicates** - Same package at multiple versions, conflicting peer dependencies

---

## Execution

### Phase 1: Detect Package Manager & Scan

Identify package manager (npm/pnpm/yarn/pip/cargo/go) from lockfiles.

Scan dependencies for all four categories. Present findings grouped by category with counts and severity:
- Critical vulnerabilities (fix immediately)
- Unused packages (safe to remove)
- Outdated packages (by semver level: major/minor/patch)
- Duplicates (version conflicts)

**Gate**: User must see full audit before proceeding.

### Phase 2: Prioritize with User

Present findings with risk assessment:
- **Critical**: Security vulnerabilities (URGENT - fix immediately)
- **Safe**: Unused dependencies (safe to remove after verification)
- **Low risk**: Minor/patch updates (backwards compatible)
- **Medium risk**: Major version updates (review breaking changes)
- **Needs review**: Duplicate resolution (check compatibility)

Offer update strategies:
```
Choose cleanup strategy:

□ Conservative - Patch only, critical security fixes
□ Moderate - Minor + patch, all security fixes
□ Aggressive - All major updates (extensive testing required)
□ Custom - Select specific categories
□ Cancel
```

**Gate**: Get user approval on which categories and strategy level.

### Phase 3: Execute Cleanup

For each approved category:

**Security vulnerabilities:**
- Update to patched version
- Check release notes for breaking changes
- Update code if API changed
- Test thoroughly

**Unused dependencies:**
- Verify not imported anywhere (check for dynamic requires)
- Remove from package manifest
- Clean lockfile
- Test immediately

**Outdated packages:**
- Check CHANGELOG for breaking changes
- Update one package at a time (or related packages together)
- Update code for API changes
- Test after each update

**Duplicates:**
- Choose version to keep (usually newer)
- Use resolutions/overrides if needed
- Rebuild lockfile
- Test compatibility

**Critical safety constraint**: One change at a time. Test after each. Commit on success, rollback on failure.

**Gate**: Tests must pass before moving to next category.

### Phase 4: Report Results

Summarize: vulnerabilities fixed (by severity), unused removed, packages updated (major/minor/patch), duplicates resolved, overall security/maintenance improvement.

---

## Safety Constraints

**CRITICAL:**
- Security fixes first - prioritize over cosmetic improvements
- One package change at a time - test between each
- Read release notes before major updates
- Commit granularly
- Don't blindly auto-fix - some fixes introduce breaking changes
- Keep lockfiles - commit package-lock.json, yarn.lock, etc.
- Check peer dependencies after updates

**If tests fail**: Rollback, check if jumping too many versions, try intermediate version, review release notes for breaking changes.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify changes don't introduce issues.

---

## Related Commands

- `/shavakan-commands:cleanup` - Full repository audit
- `/shavakan-commands:cleanup-dead-code` - Remove unused code
- `/shavakan-commands:cleanup-architecture` - Refactor structure
