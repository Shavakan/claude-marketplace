---
description: Remove obvious comments, commented code, outdated TODOs - keep 'why' explanations
---

# Remove Comment Noise

Remove comments that add zero value. Code should be self-documenting. Keep comments that explain "why" not "what".

## Execute

**1. Scan and report:**

```markdown
# Comment Noise Audit

## Obvious Comments ([X] found)
- [ ] `src/utils/math.ts:12` - "// add 1" above `count + 1`
- [ ] `src/api/users.ts:45` - "// return user" above `return user`

## Commented Code ([X] blocks)
- [ ] `src/services/api.ts:67-89` (23 lines) - old implementation
- [ ] `src/components/Form.tsx:123` (22 lines) - old JSX

## Outdated Comments ([X] found)
- [ ] `src/auth/jwt.ts:34` - "TODO: Add refresh" (done)
- [ ] `src/api/posts.ts:78` - "FIXME: Handle edge" (fixed)

## Redundant Docs ([X] found)
- [ ] `src/types/user.ts:5` - JSDoc repeats property names

## Noise ([X] found)
- [ ] `src/components/Dashboard.tsx:45` - Separator lines
- [ ] `src/utils/index.ts:12` - "End of section"

## Good Comments ([X] keeping)
✓ `src/auth/jwt.ts:56` - Explains Safari workaround
✓ `src/utils/sort.ts:23` - Documents performance trade-off

Impact: ~X comments removable, Y files cleaner
```

**2. Refactor before removing:**

Before removing, make code self-documenting:

**Bad:**
```ts
// Check if user is admin or owner
if (user.role === 'admin' || user.id === resource.ownerId)
```

**Good (remove comment by improving code):**
```ts
const canAccess = (user: User, resource: Resource) => {
  const isAdmin = user.role === 'admin';
  const isOwner = user.id === resource.ownerId;
  return isAdmin || isOwner;
};
```

**3. Ask confirmation:**
```
Remove comment noise?
- Remove X obvious comments
- Delete Y commented blocks
- Remove Z outdated TODOs
- Clean N redundant docs

Keep M valuable "why" comments

□ Yes, clean all
□ Review first
□ Obvious + commented only
```

**4. Execute:**
- Refactor for clarity where possible
- Remove noise → Test → Commit by type

**What to keep:**
- License headers
- API documentation (public interfaces)
- Complex algorithm explanations
- Workaround documentation
- Business rule explanations

**What to remove:**
- Comments that repeat code
- Commented code blocks
- Separator lines
- Outdated TODOs/FIXMEs

**Output:**
```
✓ Comment Cleanup Complete

Removed:
- 45 obvious comments
- 12 commented code blocks
- 8 outdated TODOs
- 15 redundant docs

Refactored:
- 23 improved with better naming
- 12 extracted to named functions

Kept:
- 34 "why" explanations
- 12 algorithm docs
- 8 workaround docs

Impact: 234 lines removed, 56 files cleaner
Tests: Passing ✓
```

## Related

- `/shavakan.cleanup` - Full audit
- `/shavakan.cleanup.dead-code` - Remove unused code
