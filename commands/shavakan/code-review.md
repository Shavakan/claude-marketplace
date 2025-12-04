---
description: Run full AI code review cycle on current PR branch
---

# Code Review Cycle

Iteratively review local changes, fix issues, and re-review until clean.

## Prerequisites

Verify `shavakan-agents:code-reviewer` is installed:

```bash
if ! claude plugins list 2>/dev/null | grep -q "shavakan-agents"; then
  echo "MISSING: shavakan-agents plugin required"
  echo "Install: claude plugins add shavakan-agents@shavakan"
  exit 1
fi
```

---

## Additional Instructions

$ARGUMENTS

---

## Execution

### Initialize

Track iterations:
- `iteration_count = 0`
- `issues_by_iteration = []`
- `max_iterations = 5`

### Review Loop

**Repeat until no actionable issues or max_iterations reached:**

1. **Run Review**
   - Increment `iteration_count`
   - Launch `shavakan-agents:code-reviewer` agent via Task tool
   - Parse findings: 🔴 Critical, 🟠 High, 🟡 Medium

2. **Check Exit Condition**
   - If no findings at any priority → exit loop, report success
   - If `iteration_count >= max_iterations` → exit loop, report remaining issues

3. **Record Issues**
   - Store findings in `issues_by_iteration[iteration_count]`
   - Include: file:line, type, description, severity

4. **Fix Issues**
   - Address all actionable issues (🔴🟠🟡) in priority order
   - Use Edit tool for code fixes
   - Stage changes: `git add -A`

5. **Continue Loop**

### Report Summary

Output structured iteration report:

```
## Code Review Summary

**Iterations**: {iteration_count}
**Final Status**: {Clean | {N} issues remaining}

### Iteration Details

#### Iteration 1
- [file:line] type - description → Fixed
- [file:line] type - description → Fixed

#### Iteration 2
- [file:line] type - description → Fixed

### Statistics
- Total issues found: N
- Issues fixed: M
- Time per iteration: ~Xs average
```

---

## Constraints

- Max 5 iterations to prevent infinite loops
- Stop immediately if agent reports "No critical or high-priority issues found"
- Don't fix style-only issues unless explicitly flagged as actionable
- Each iteration must have at least one fix to continue (no empty iterations)

---

## Error Handling

- **Agent unavailable**: Exit with install instructions
- **Max iterations reached**: Report remaining issues, recommend manual review
- **Git dirty state**: Warn but continue (agent handles this)
- **Fix breaks tests**: Rollback fix, mark issue as "requires manual intervention"
