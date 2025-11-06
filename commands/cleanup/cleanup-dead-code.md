---
description: Remove unused imports, functions, variables, commented blocks, unreachable code
---

# Remove Dead Code

Find and safely remove unused code: imports, functions, variables, commented blocks, unreachable code, unused files.

## Execute

**1. Scan and report:**

```markdown
# Dead Code Audit

## Unused Imports ([X] found)
- [ ] `src/api/users.ts:3` - `import { oldHelper }`
- [ ] `src/components/Form.tsx:5` - `import { unused }`

## Unused Functions ([X] found)
- [ ] `src/utils/legacy.ts:45` - `calculateOldMetric()` (0 refs)
- [ ] `src/helpers/math.ts:12` - `oldFormula()` (0 refs)

## Unused Variables ([X] found)
- [ ] `src/config/old.ts:8` - `LEGACY_TIMEOUT` (0 refs)

## Commented Code ([X] blocks)
- [ ] `src/services/api.ts:67-89` (23 lines)
- [ ] `src/components/Dashboard.tsx:123-145` (22 lines)

## Unreachable Code ([X] locations)
- [ ] `src/workflow/engine.ts:234` - after return statement

## Unused Files ([X] files)
- [ ] `src/utils/legacy-helper.ts` - no imports
- [ ] `tests/old-feature.test.ts` - feature deleted

Impact: ~X lines, ~Y files, ~Z KB bundle reduction
```

**2. Ask confirmation:**
```
Remove all dead code?
- Delete X unused imports
- Remove Y unused functions
- Delete Z commented blocks
- Remove N unreachable sections
- Delete M unused files

□ Yes, remove all
□ Review list first
□ Safe items only (imports, comments)
```

**3. Execute safely:**
- Remove item → Test → Pass? Continue : Revert + report "Not actually dead"
- Commit atomically by type

**Detection:**
- Unused imports: No references in file
- Unused functions: Zero call sites (grep codebase)
- Commented code: 5+ consecutive comment lines with valid syntax
- Unreachable: Code after unconditional returns/throws
- Unused files: No imports from other files

**Don't remove:**
- Public APIs (even if unused internally)
- Code called via strings (plugin systems)
- Code in templates/configs
- Deliberate feature flags

**Safe to remove:**
- Private functions with 0 calls
- Imports with 0 references
- Commented code >6 months old
- Code after returns

**Output:**
```
✓ Dead Code Removed

Removed:
- 23 unused imports
- 7 unused functions
- 12 commented blocks
- 3 unreachable sections
- 5 unused files

Impact: 456 lines removed, ~15KB smaller bundle
Tests: Passing ✓
```

## Related

- `/shavakan.cleanup` - Full audit
- `/shavakan.cleanup.deps` - Remove unused packages
