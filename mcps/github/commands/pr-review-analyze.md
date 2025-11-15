---
description: Analyze PR review comments and generate fix summary for another Claude instance
---

# PR Review Analysis

Fetch GitHub PR review comments, categorize by severity, generate actionable fix summary for another Claude Code instance.

## User Input

You MUST consider the user input in `$ARGUMENTS`: PR URL or number.

If empty, abort: "Usage: /pr-review-analyze <PR_URL or PR_NUMBER>"

## Severity Classification

**Blocking:** Security vulnerabilities, data corruption risks, breaking API changes, critical logic errors

**High Priority:** Performance bugs, race conditions, incomplete error handling, correctness issues

**Medium Priority:** Code quality improvements, refactoring opportunities, minor optimizations

**Low Priority:** Style suggestions, documentation improvements, code deduplication

## Execution

**Phase 1: Parse Input**

Parse PR identifier from $ARGUMENTS

**Gate:** Confirm PR identifier. Proceed to fetch data? (y/n)

**Phase 2: Fetch Data**

Fetch PR data (prefer GitHub MCP, fallback to gh CLI if unavailable):
- Extract review threads with: comments, file paths, line numbers, reviewer names, text
- For each comment, get: `outdated` flag (code changed) and thread `isResolved` status (manually resolved)
- If both fail, abort: "Unable to fetch PR data. Install gh CLI or configure GitHub MCP"

**Phase 3: Report Outdated Bot Comments**

Report outdated bot comments (already fixed by code changes):
- Identify comments from Claude (username contains "claude") or Copilot (username "github-copilot")
- For bot comments where `outdated: true` AND `isResolved: false`, list them separately
- Report: "Found N outdated unresolved bot comments (already fixed by code changes but not manually resolved)"
- Note: GitHub API doesn't support auto-resolving threads programmatically

**Phase 4: Categorize**

Categorize active unresolved comments:
- Only categorize comments where `outdated: false` AND `isResolved: false`
- Skip outdated comments (already reported in Phase 3) and resolved comments
- Analyze content and context of active unresolved comments
- Apply severity definitions above based on actual impact
- Flag ambiguous comments as "Needs Severity Review"

**Gate:** Found N comments (X blocking, Y high priority). Generate summary? (y/n)

**Phase 5: Generate Summary**

Generate summary with blocking issues first, lower priority after

## Fix Summary Format

```markdown
## Context
PR: https://github.com/org/repo/pull/42
Branch: fix/auth-validation

## Outdated Comments (Already Fixed)
N bot comments are outdated (code changed) but not manually resolved. No action needed.

## Blocking Issues

1. **auth.py:127** - SQL injection vulnerability
   - Problem: User input in f-string query
   - Risk: Arbitrary SQL execution
   - Fix: Use parameterized query with $1, $2 placeholders

2. **session.py:89** - API key logged in exception handler
   - Problem: Exception traceback includes API key from config dict
   - Risk: Credentials exposed in error logs
   - Fix: Redact api_key before client initialization

## High Priority

1. **cache.py:203** - Redis KEYS blocks event loop [Copilot]
   - Problem: KEYS is O(n) and blocks Redis
   - Risk: Performance degradation on large keyspaces
   - Fix: Replace `redis.keys(pattern)` with `redis.scan_iter(match=pattern)`

## Instructions
1. Fix all blocking issues
2. Run test suite to verify no regressions
3. Commit: "fix: address security and performance review findings"
4. Push to same branch
```

## Edge Cases

- **No review comments:** Output "No review comments found"
- **All comments outdated or resolved:** Output "No active unresolved comments requiring attention"
- **No blocking issues:** State explicitly in summary
- **Unclassifiable comments:** Separate "Needs Severity Review" section
- **Invalid PR:** Abort with tool error message

## Constraints

- Preserve exact technical terms from comments
- Don't fabricate fixes not mentioned by reviewers
- Keep each issue to 3-5 sentences max
