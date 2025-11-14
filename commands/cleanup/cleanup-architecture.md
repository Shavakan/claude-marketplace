---
description: Refactor structure - split god objects, break circular deps, improve separation of concerns
---

# Refactor Architecture

Improve code structure: split god objects, break circular dependencies, improve separation of concerns.

## Prerequisites

**Safety requirements:**
1. Git repository with clean working tree
2. All tests passing before refactoring
3. Backup branch created automatically
4. Test validation after each refactor

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

Identify and fix architecture issues that make code hard to maintain: god objects, circular dependencies, poor layer separation, high complexity, and long parameter lists.

### Architecture Smells

**God objects** - Files >300 lines or classes with too many responsibilities (detect via file size, import count, mixed concerns)

**Circular dependencies** - Module A imports B, B imports A (creates tight coupling, import errors)

**Poor separation** - Files mixing layers (controller + service + repository in one file, UI with business logic)

**High complexity** - Functions with cyclomatic complexity >10, deeply nested conditionals, >50 lines

**Long parameter lists** - Functions with 5+ parameters (should use options objects)

---

## Execution

### Phase 1: Detect Architecture Issues

Scan codebase for architecture smells using appropriate analysis tools for the language. For each issue found:
- Identify the specific problem (what makes this a god object? which modules form the cycle?)
- Assess impact (how is this hurting maintainability?)
- Propose solution (split by domain? extract interface? introduce layer?)

Present findings with prioritization:
- **Critical**: Circular deps causing build issues, god objects blocking development
- **High**: Poor separation causing bugs, complexity >15
- **Medium**: Large files that are manageable, complexity 10-15

**Gate**: User must review full audit before proceeding.

### Phase 2: Prioritize with User

Present audit findings with impact assessment:
```
Refactor architecture issues?

□ Safest - Extract complex functions + convert long param lists
□ Low risk - Split god objects by domain boundaries
□ Medium risk - Break circular deps + separate mixed layers
□ High risk - Major architectural refactoring
□ Custom - Select specific issues
□ Cancel
```

**Gate**: Get user approval on which issues and risk level to address.

### Phase 3: Refactor Systematically

For each approved issue:

**Split god objects:**
- Analyze file to identify distinct responsibilities (auth vs profile vs settings)
- Propose domain-driven split with clear boundaries
- Create new files for each responsibility
- Move methods to appropriate files
- Update all imports
- Test after each file is moved

**Break circular dependencies:**
- Analyze cycle to understand why it exists
- Choose approach: extract shared types, introduce interface, dependency inversion
- Implement solution (e.g., create UserSummary type to break User ↔ Post cycle)
- Update imports
- Verify no circular reference remains

**Separate layers:**
- Identify mixed concerns (route handling + validation + business logic + DB in one file)
- Create appropriate layer files (Controller, Validator, Service, Repository)
- Move logic to correct layers
- Update dependencies to flow one direction
- Test layer boundaries work correctly

**Reduce complexity:**
- Extract methods for logical blocks
- Replace nested conditionals with guard clauses
- Introduce state pattern for workflow steps
- Test behavior unchanged

**Simplify parameters:**
- Create options interface with all parameters
- Update function signature
- Update all call sites
- Test all cases still work

**Critical**: Each refactoring must preserve exact behavior. Tests must pass. If tests fail, rollback and investigate the difference.

**Gate**: Tests must pass before moving to next refactoring.

### Phase 4: Report Results

Summarize improvements: god objects split (N → M files), circular deps broken (N cycles eliminated), complexity reduced (N functions simplified), maintainability impact.

---

## Refactoring Patterns

### Split God Object
Extract cohesive responsibilities into focused modules:
```typescript
// Before: UserService (847 lines, does everything)
class UserService {
  authenticate() { }
  updateProfile() { }
  sendNotification() { }
}

// After: Split by domain
class AuthService { authenticate() { } }
class ProfileService { updateProfile() { } }
class NotificationService { sendNotification() { } }
```

### Break Circular Dependency
Extract shared types or introduce interfaces:
```typescript
// Before: User imports Post, Post imports User
// Create shared type
interface UserSummary { id: string; name: string; }

// User can import Post (full)
// Post only imports UserSummary (breaks cycle)
```

### Separate Layers
Controller → Service → Repository:
```typescript
// Before: Everything in one function
async function createOrder(req, res) {
  if (!req.body.items) return res.status(400).send();
  const total = calculateTotal(req.body.items);
  const order = await db.orders.create({...});
  res.json(order);
}

// After: Proper layering
// Controller: HTTP handling only
// Service: Business logic
// Repository: Database access
```

---

## Safety Constraints

**CRITICAL:**
- One refactoring at a time - test after each structural change
- Preserve exact behavior - all tests must pass
- Commit granularly - each refactoring gets its own commit
- Never batch refactors - if one breaks, you can't identify which
- Keep interfaces stable - don't break public APIs
- Use types to catch breaking changes at compile time

**If tests fail**: Rollback immediately, identify the specific change that broke behavior, understand why it's different from original.

---

## After Cleanup

**Review with code-reviewer agent before pushing:**

Use `shavakan-agents:code-reviewer` to verify refactorings don't introduce issues.

---

## Related Commands

- `/shavakan-commands:cleanup` - Full repository audit
- `/shavakan-commands:cleanup-dead-code` - Remove unused code
- `/shavakan-commands:cleanup-duplication` - Remove code duplication
