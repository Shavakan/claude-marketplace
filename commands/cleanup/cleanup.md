---
description: Comprehensive repository audit and cleanup (dead code, comments, docs, architecture, deps)
---

# Repository Cleanup Audit

Scan the codebase and generate a comprehensive cleanup report. Then execute improvements based on user priorities.

## Execution Steps

**1. Scan for issues:**
- Code quality: Large functions (>50 lines), duplicates, high complexity, deep nesting
- Dead code: Unused imports/functions/variables, commented blocks, unreachable code
- Comments: Obvious comments, outdated TODOs, commented code
- Docs: Outdated API docs, dead links, removed feature references
- Architecture: God objects (>500 lines), circular deps, poor separation
- Dependencies: Unused packages, outdated versions, security CVEs
- Organization: Misplaced files, inconsistent naming

**2. Generate report:**

```markdown
# Cleanup Audit - [timestamp]

## Summary
Total: [X] | Critical: [X] | High: [X] | Medium: [X] | Low: [X]

## Dead Code (Critical - [count])
- [ ] `path:line` - Unused import `name`
- [ ] `path:line` - Function `name()` (0 references)

## Security (Critical - [count])
- [ ] `package` - CVE-XXXX (upgrade to vX.X)

## Architecture (High - [count])
- [ ] `path` - God object (X lines)
- [ ] `paths` - Circular dependency

## Comments (Medium - [count])
- [ ] `path:line` - Obvious: "// add 1" above count++

## Organization (Low - [count])
- [ ] `path` - Misplaced test file
```

**3. Ask priority:**
```
Clean up what?
□ Critical (security, dead code)
□ Critical + High (+ architecture)
□ Critical + High + Medium (+ comments)
□ All
□ Custom
```

**4. Create execution plan:**
```markdown
# Plan

Phase 1: Safe Removals
- Remove X unused imports
- Delete Y commented blocks

Phase 2: Refactoring
- Extract Z large functions
- Split N god objects

Phase 3: Dependencies
- Remove M unused packages
- Update K outdated deps
```

**5. Execute with test verification:**
- Make change → Run tests → Pass? Commit : Revert
- Show progress after each phase
- Stop on test failures

**Report format after each phase:**
```
✓ Phase 1: Safe Removals
- 15 unused imports removed
- 8 commented blocks deleted
- Tests passing ✓
- Committed: "Remove unused imports and dead code"
```

## Safety

- Always test after changes
- Commit per phase
- Never remove without understanding purpose
- Ask before major refactors

## Related

- `/shavakan.cleanup.dead-code` - Focus: unused code only
- `/shavakan.cleanup.comments` - Focus: comments only
- `/shavakan.cleanup.docs` - Focus: documentation only
- `/shavakan.cleanup.architecture` - Focus: structure only
- `/shavakan.cleanup.deps` - Focus: dependencies only
