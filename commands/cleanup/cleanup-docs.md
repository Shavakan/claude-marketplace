---
description: Sync documentation with code - fix dead links, update API docs, remove outdated content
---

# Sync Documentation with Code

Ensure docs accurately reflect current codebase. Remove outdated content, fix dead links, update API docs.

## Execute

**1. Scan and report:**

```markdown
# Documentation Audit

## Outdated API Docs ([X] found)
- [ ] `docs/api/payments.md` - references removed `/v1/charge`
- [ ] `docs/api/users.md` - missing new `include` parameter

## Dead Links ([X] found)
- [ ] `docs/architecture.md:23` - broken `./diagrams/system.png`
- [ ] `CONTRIBUTING.md:45` - 404 to wiki

## Removed Features ([X] found)
- [ ] `README.md:56` - mentions real-time notifications (removed v2.0)
- [ ] `docs/features.md:12` - references legacy auth

## Outdated Examples ([X] found)
- [ ] `docs/quickstart.md:34` - old API signature
- [ ] `README.md:78` - deprecated import paths

## Wrong Paths ([X] found)
- [ ] `docs/config.md:12` - points to old location
- [ ] `CONTRIBUTING.md:23` - wrong test directory

## Missing Docs ([X] APIs)
- [ ] `src/api/webhooks.ts` - public API undocumented
- [ ] `src/services/billing.ts` - complex service needs docs

## Good Docs ([X] files)
✓ `docs/api/auth.md` - accurate and complete
✓ `SECURITY.md` - current

Impact: X docs to update, Y links to fix, Z sections to remove
```

**2. Ask priority:**
```
Fix what?
□ Critical (dead links, wrong examples)
□ High (API docs, README)
□ Medium (paths, missing docs)
□ All
□ Custom
```

**3. Fix by type:**

**Dead links:**
- Find target → Update path or remove link → Verify

**API docs:**
- Read implementation → Extract params/responses → Update docs → Add examples

**Outdated content:**
- Find when removed → Delete sections → Add deprecation notice if needed

**Wrong paths:**
- Find current location → Update references → Verify

**Missing docs:**
- Document public APIs → Add usage examples → Document errors

**4. Verify:**
- All links work
- Examples run correctly
- Paths exist
- Docs match implementation

**Output:**
```
✓ Documentation Synced

Fixed:
- 12 dead links
- 8 outdated API docs
- 5 removed feature refs
- 15 outdated examples
- 7 wrong paths

Added:
- 6 missing API docs
- 3 configuration docs
- 4 error handling guides

Verified:
- All links working ✓
- All examples tested ✓
- All paths correct ✓

Coverage: 89% public APIs documented
Accuracy: Docs match implementation ✓
```

## API Doc Template

```markdown
### POST /api/users

Create user account.

**Request:**
\`\`\`json
{
  "email": "string (required)",
  "password": "string (required, min 8 chars)",
  "name": "string (optional)"
}
\`\`\`

**Response (201):**
\`\`\`json
{
  "id": "string",
  "email": "string",
  "createdAt": "ISO 8601"
}
\`\`\`

**Errors:**
- 400 - Invalid email/weak password
- 409 - Email exists
- 500 - Internal error

**Example:**
\`\`\`ts
const user = await fetch('/api/users', {
  method: 'POST',
  body: JSON.stringify({...})
});
\`\`\`
```

## Safety

- Don't remove: Changelog history, migration guides, deprecation notices, license
- Safe to update: Current docs, API endpoints, code examples, paths

## Related

- `/shavakan.cleanup` - Full audit
- `/shavakan.dev-docs` - Create implementation docs
