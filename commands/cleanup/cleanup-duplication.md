---
description: Find and refactor duplicated code - similar blocks, copy-paste functions, repeated strings
---

# Remove Code Duplication

Find DRY (Don't Repeat Yourself) violations and refactor duplicated code into reusable abstractions.

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before refactoring
3. Backup branch created automatically
4. Test validation after each refactoring

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

Identify and eliminate code duplication - extract common patterns into reusable functions, constants, and abstractions.

### Duplication Types

**Duplicated blocks** - Similar/identical code in multiple files (>80% similarity, 5+ lines), copy-pasted logic with minor variations

**Duplicated functions** - Same logic with different names, utility functions reimplemented across files, helper methods duplicated in multiple classes

**Magic strings/numbers** - Repeated literals (strings like "admin", "error" used 3+ times), hard-coded numbers (excluding 0, 1, -1), configuration values scattered throughout code

**Similar patterns** - Nearly identical implementations with slight variations, common algorithms reimplemented differently, parallel code structures that could be unified

---

## Execution

### Phase 1: Detect Duplication

Scan codebase for duplicated code. Look for similar blocks, repeated functions, magic values, and patterns that could be unified.

For each duplication found, capture location, similarity percentage, and proposed extraction. Present findings grouped by type with counts and estimated impact.

**Gate**: User must review full audit before proceeding.

### Phase 2: Prioritize Refactorings

Present audit findings with risk assessment:
```
Refactor code duplication?

□ Safest - Extract magic strings/numbers to constants
□ Low risk - Consolidate identical functions + extract utilities
□ Medium risk - Extract duplicated blocks + parameterize variations
□ High risk - Unify similar patterns into abstractions
□ Custom - Select specific duplications
□ Cancel
```

**Gate**: Get user approval on which duplications to refactor.

### Phase 3: Refactor Systematically

For each approved duplication:

**Extract duplicated blocks:** Identify common functionality, create shared function with appropriate parameters, replace all occurrences, preserve exact behavior

**Consolidate functions:** Compare implementations to find canonical version, merge variations into single configurable function, update all call sites, remove duplicate definitions

**Extract magic values:** Create constants with descriptive names (ROLE_ADMIN, DEFAULT_TIMEOUT), replace all occurrences with constant reference, group related constants together

**Unify patterns:** Design common abstraction that handles all cases, implement generic version with configuration, migrate each usage, remove old implementations

**Critical**: One refactoring at a time. Test after each. Commit on success, rollback on failure.

**Gate**: Tests must pass before moving to next refactoring.

### Phase 4: Report Results

Summarize: duplicated blocks extracted, functions consolidated, magic values extracted to constants, patterns unified, code reduction percentage, maintainability improvement.

Delete the backup branch after successful completion:
```bash
git branch -D "$BACKUP_BRANCH"
```

---

## When NOT to Refactor

**Don't extract if:**
- Only 2 occurrences (wait for third) - "Rule of Three"
- Code happens to look similar but serves different purposes
- Abstraction would be more complex than duplication
- Duplication is in different contexts (tests vs. production code)
- Changes are likely to diverge in the future

**Bad extraction example:**
```typescript
// Don't do this - over-abstraction for trivial code
function addOneToNumber(n: number): number {
  return n + 1;
}
// Just use n + 1 directly
```

---

## Refactoring Patterns

### Extract Function
```typescript
// Before: Duplicated in 3 files
if (user.role === 'admin' || user.role === 'owner') {
  return true;
}

// After: Extract to shared utility
// utils/auth.ts
export function canManageResources(user: User): boolean {
  return user.role === 'admin' || user.role === 'owner';
}

// Usage
import { canManageResources } from './utils/auth';
if (canManageResources(user)) { }
```

### Extract Constants
```typescript
// Before: Magic strings repeated
if (user.role === 'admin') { }

// After: Extract to constants
// constants/roles.ts
export const ROLE_ADMIN = 'admin';

// Usage
import { ROLE_ADMIN } from './constants/roles';
if (user.role === ROLE_ADMIN) { }
```

### Parameterize Variations
```typescript
// Before: Similar functions with variations
function fetchUsers() { return api.get('/users'); }
function fetchPosts() { return api.get('/posts'); }

// After: Single parameterized function
function fetchResource<T>(resource: string): Promise<T[]> {
  return api.get(`/${resource}`);
}

// Usage
const users = await fetchResource<User>('users');
```

---

## Safety Constraints

**CRITICAL:**
- One refactoring at a time - test between each
- Preserve behavior exactly - all tests must pass
- Follow "Rule of Three" - extract when you have 3+ duplicates, not 2
- Name clearly - extracted functions should have descriptive names
- Don't over-abstract - complex abstraction worse than simple duplication
- Test thoroughly - edge cases may differ between duplicates
- Commit granularly - each extraction gets its own commit

**If tests fail**: Rollback immediately, identify which specific extraction broke behavior, understand the difference between duplicates.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify refactorings don't introduce issues.

---

## Related Commands

- `/shavakan-commands:cleanup` - Full repository audit
- `/shavakan-commands:cleanup-architecture` - Refactor god objects
- `/shavakan-commands:cleanup-dead-code` - Remove unused code
