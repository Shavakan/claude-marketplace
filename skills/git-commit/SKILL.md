---
name: git-commit
description: Create git commits with succinct technical messages. Activates when user requests git commit creation.
---

# Git Commit

## Overview

Create clean, technical git commit messages in logical units. Analyze changes and group related modifications into separate commits.

## Process

1. Run `git status` and `git diff` to analyze all changes
2. Apply grouping algorithm to identify commit units
3. For each unit:
   - Stage only files for that unit
   - Draft succinct message (1-2 sentences max)
   - Create commit
4. Verify all changes are committed

## Grouping Algorithm

1. **Categorize** each file by type (priority order: Fix > Feature > Refactor > Test > Doc > Config)
2. **Build dependency graph** (types before code, implementation before tests, refactors before fixes)
3. **Merge units** if: same directory AND same type AND <5 files total
4. **Keep separate** if: different types OR cross-module changes OR >4 files in group
5. **Order commits**: dependencies first, then independents, docs last

**Change types:**
- **Fix**: Bug fixes addressing specific issues
- **Feature**: New functionality in related files
- **Refactor**: Code restructuring without behavior changes
- **Test**: Test additions/modifications (commit with implementation if coupled)
- **Doc**: Documentation updates
- **Config**: Build config, dependencies, tooling
- **Types**: Type definition changes (commit before code using them)

**Coupling boundaries:**
- **Tightly coupled** (one commit): Type changes + code using them, renames affecting imports, implementation + its tests if <3 files
- **Independent** (separate commits): Different modules, unrelated bug fixes, separate features, docs

**Examples:**
```
✅ Good grouping:
  Commit 1: Add null check to user validation (src/validation/user.ts)
  Commit 2: Update UserForm to use new validation (src/forms/UserForm.tsx, src/forms/UserForm.test.ts)
  Commit 3: Document validation rules (docs/api/validation.md)

❌ Bad grouping:
  Commit 1: Update validation and fix tests and add docs (mixes 3 types, unclear scope)
```

**Circular dependencies:**
If fix A requires refactor B, create minimal commits preserving buildability: refactor first, then fix.

## Message Guidelines

**Focus on WHAT changed in the code:**
- "Add null checks to user validation"
- "Extract database logic into separate module"
- "Fix memory leak in event handler cleanup"

**Avoid progress/milestone language:**
- ❌ "Implement user authentication feature"
- ❌ "Continue work on API endpoints"
- ❌ "Add tests and improve code quality"

## Edge Cases

**Single logical unit**: All changes tightly coupled → one commit
**Mixed changes in one file**: Use `git add -p` to stage hunks separately
**Too many units (>6)**: Present grouping plan, ask user to confirm or merge

## Important

- Never include "Co-Authored-By: Claude" or "Generated with Claude Code"
- No heredoc format with attribution footers
- Describe technical change, not project progress
- Default to multiple small commits over one large commit
- Ensure every file is staged exactly once
