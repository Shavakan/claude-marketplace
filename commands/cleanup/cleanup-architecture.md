---
description: Refactor structure - split god objects, break circular deps, improve separation of concerns
---

# Refactor Architecture

Improve code structure: split god objects, break circular dependencies, improve separation of concerns.

## Execute

**1. Scan and report:**

```markdown
# Architecture Audit

## God Objects ([X] found)
- [ ] `src/services/UserService.ts` (847 lines) - handles auth, profile, settings, notifications
- [ ] `src/utils/helpers.ts` (623 lines) - mixed responsibilities

## Circular Dependencies ([X] found)
- [ ] `src/models/User.ts` ↔ `src/models/Post.ts`
- [ ] `src/services/A.ts` ↔ `src/services/B.ts`

## Poor Separation ([X] locations)
- [ ] `src/api/orders.ts` - mixes validation, logic, database queries
- [ ] `src/components/Dashboard.tsx` - business logic in UI

## High Complexity ([X] functions)
- [ ] `src/workflow/engine.ts:120` - `executeWorkflow()` (complexity: 23)
- [ ] `src/utils/transform.ts:45` - `process()` (complexity: 18)

## Long Parameter Lists ([X] functions)
- [ ] `src/api/users.ts:34` - `createUser()` (7 params)
- [ ] `src/utils/format.ts:67` - `formatData()` (6 params)

## Data Clumps ([X] found)
- [ ] Same 4 params repeated in 8 functions - should be type

Impact: X files to refactor, Y functions to split
```

**2. Ask priority:**
```
Refactor what?
□ God objects only (split by domain)
□ God objects + circular deps
□ God objects + circular + separation
□ All architecture issues
□ Custom
```

**3. Create refactoring plan:**

**God object split:**
```
UserService.ts (847 lines) →
  services/auth/AuthService.ts (auth logic)
  services/users/ProfileService.ts (profile)
  services/users/SettingsService.ts (settings)
  services/notifications/UserNotificationService.ts (notifs)
```

**Circular dependency break:**
```
User ↔ Post →
  User depends on Post ✗
  Create UserSummary type
  Post depends on UserSummary ✓
```

**Separation improvement:**
```
OrderController (mixed) →
  OrderController (route handling)
  OrderValidator (validation)
  OrderService (business logic)
  OrderRepository (database)
```

**4. Execute with tests:**
- Make refactor → Run tests → Pass? Commit : Revert
- One refactor at a time
- Preserve behavior (tests must pass)

**Refactoring patterns:**

**Extract service:**
```ts
// Before: God object
class UserService {
  authenticate() { }
  updateProfile() { }
  sendNotification() { }
}

// After: Split by domain
class AuthService {
  authenticate() { }
}
class ProfileService {
  updateProfile() { }
}
class NotificationService {
  sendNotification() { }
}
```

**Break circular:**
```ts
// Before: Circular
// User.ts
import { Post } from './Post';
class User {
  posts: Post[];
}

// Post.ts
import { User } from './User';
class Post {
  author: User;
}

// After: Use summary type
// User.ts (no Post import)
class User {
  id: string;
  name: string;
}

// Post.ts
import { User } from './User';
class Post {
  author: User; // or author: UserSummary
}
```

**Separate concerns:**
```ts
// Before: Mixed
async function createOrder(req, res) {
  // Validation
  if (!req.body.items) return res.status(400).send();

  // Business logic
  const total = calculateTotal(req.body.items);

  // Database
  const order = await db.orders.create({...});

  res.json(order);
}

// After: Layered
// OrderController
async function createOrder(req, res) {
  const validated = OrderValidator.validate(req.body);
  const order = await OrderService.create(validated);
  res.json(order);
}

// OrderValidator
class OrderValidator {
  static validate(data) { }
}

// OrderService
class OrderService {
  static async create(data) {
    const total = this.calculateTotal(data.items);
    return OrderRepository.create({...});
  }
}

// OrderRepository
class OrderRepository {
  static async create(data) { }
}
```

**Output:**
```
✓ Architecture Refactored

God objects split:
- UserService → 4 services
- helpers.ts → 3 modules

Circular deps broken:
- User ↔ Post (introduced UserSummary)
- ServiceA ↔ ServiceB (extracted interface)

Separation improved:
- OrderController now layered (controller → service → repository)
- Dashboard extracted business logic to hooks

Complexity reduced:
- executeWorkflow() split into 4 functions
- process() simplified (complexity 23 → 8)

Tests: All passing ✓
Impact: 12 files refactored, better maintainability
```

## Safety

- Always preserve behavior (tests must pass)
- One refactor at a time
- Commit after each successful refactor
- Use TypeScript to catch breaking changes
- Keep interfaces stable for public APIs

## Related

- `/shavakan.cleanup` - Full audit
- `/shavakan.dev-docs` - Plan large refactors
