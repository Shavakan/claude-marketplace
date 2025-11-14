---
description: Sync documentation with code - fix dead links, update API docs, remove outdated content
---

# Sync Documentation with Code

Ensure docs accurately reflect current codebase. Remove outdated content, fix dead links, update API docs.

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before changes
3. Backup branch created automatically
4. Validation after each doc update category

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

Synchronize documentation with current codebase state - eliminate inaccuracies, fix broken references, ensure examples work.

### Documentation Issues

**Dead links** - Internal links to moved/deleted files, external 404s, broken anchor references

**Outdated API docs** - Function signatures changed, parameters added/removed/renamed, return types mismatched, deprecated methods still documented

**Stale content** - Removed features still documented, old tooling instructions, architecture docs contradicting code, examples using deprecated APIs

**Incorrect paths** - Wrong import examples, outdated file structure diagrams, command examples referencing moved files

**Missing docs** - New features without documentation, API endpoints undescribed, configuration options undocumented, breaking changes not in changelog

---

## Execution

### 1. Audit Documentation

Scan all docs and cross-reference with codebase. Documentation typically lives in: README.md, docs/ directory, API documentation (JSDoc/docstrings), CHANGELOG.md, CONTRIBUTING.md, inline examples.

For each issue found, capture location, problem description, and suggested fix. Present findings grouped by category with counts and severity.

### 2. Prioritize Fixes

Present audit findings with impact assessment:
- **Critical**: Dead links breaking navigation, API docs with wrong signatures, missing docs for public APIs
- **High**: Stale setup instructions, removed features still documented, incorrect import paths
- **Medium**: Outdated architecture diagrams, deprecated tool references
- **Low**: Broken external links (if archived), minor formatting issues

### 3. Fix Issues

For each approved category:

**Dead links:** Update to new location if file moved, remove if deleted, find replacement for broken external URLs, fix anchor links to match current headings

**Outdated API docs:** Compare documented signatures with actual code, update parameters/return types to match reality, add version notes ("Changed in v2.0.0"), note breaking changes in CHANGELOG

**Stale content:** Remove sections about deleted features, update setup instructions for current tools, note what replaced old features, update architecture diagrams, test and fix code examples

**Incorrect paths:** Find current file locations, update import examples, fix command line examples, correct file tree diagrams

**Missing docs:** Document new public APIs, add configuration option descriptions, note breaking changes in CHANGELOG, write migration guides for major changes

**Critical**: Test all code examples actually work. Verify links resolve correctly. One category at a time with test validation between each.

### 4. Report Results

Summarize: dead links fixed, API docs synchronized, stale content removed/updated, paths corrected, missing docs added, documentation accuracy improvement.

---

## Documentation Priority Tiers

**Essential** (always accurate): README.md, API documentation, CHANGELOG.md, migration guides, setup/installation

**Important** (reasonably current): Architecture docs, contributing guide, examples, troubleshooting

**Nice-to-have** (update as needed): Tutorials, design decisions, performance notes, comparisons

---

## Example API Doc Correction

```markdown
<!-- Before (outdated) -->
## authenticate(username, password)
Authenticates a user with username and password.

<!-- After (corrected) -->
## authenticate(credentials)
Authenticates a user with credentials object.

**Parameters:**
- `credentials.email` (string) - User email
- `credentials.password` (string) - User password

**Changed in v2.0.0:** Previously accepted separate username and password parameters.
```

---

## Safety Constraints

**CRITICAL:**
- Verify content is truly outdated before removing - check git history
- Test all code examples actually compile and run
- Keep migration context - when removing features, note what replaced them
- Update CHANGELOG when fixing API documentation errors
- One category at a time with test validation
- Commit granularly - separate commits for dead links, API updates, etc.
- Check markdown renders correctly after edits

**If examples fail**: Don't update docs to match broken code. Fix the code or mark the feature as broken in docs with an issue reference.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify changes don't introduce issues.

---

## Related Commands

- `/shavakan-commands:cleanup` - Full repository audit
- `/shavakan-commands:cleanup-dead-code` - Remove unused code
