---
description: Update dev docs context and tasks before compaction
---

# Dev Docs Update - Pre-Compaction Context Preservation

You are about to run out of context and the conversation will be compacted. Before that happens, you need to preserve the current state so work can continue seamlessly in the next session.

## Your Task

1. **Find the active dev docs directory**
   - Look in `~/git/project/dev/active/` for the current task
   - If multiple exist, ask the user which one to update

2. **Update context.md**:
   - Add "Last Updated" timestamp
   - Add any new architectural decisions made
   - Add any new key files discovered or modified
   - Update integration points if they changed
   - **Most Important:** Add a "Next Steps" section describing:
     - What was just completed
     - What should be done next
     - Any blockers or issues to be aware of
     - Specific files or functions to focus on

3. **Update tasks.md**:
   - Mark completed tasks with `[x]`
   - Add any new tasks discovered during implementation
   - Add timestamp to "Last Updated"
   - Reorder tasks if priorities changed

4. **Summarize what you updated** so the user knows what changed

## Output Format

After updating both files, provide a brief summary:

```markdown
✓ Updated dev docs in ~/git/project/dev/active/[task-name]/

**Context Updates:**
- Added decision about [X]
- Noted new key file: [path]
- Next steps: [brief description]

**Task Updates:**
- Marked complete: [task 1], [task 2]
- Added new task: [task 3]

**Status:** Ready for compaction. Next session should start with "continue" and read the dev docs.
```

## Best Practices

- Be honest about what's complete vs in-progress
- Flag any technical debt or shortcuts taken
- Note any assumptions that should be validated
- If tests are failing, document why
- If something is partially implemented, explain what's left

## Context Template to Add

```markdown
## Recent Progress (Updated: [timestamp])

### Completed
- [What was finished]
- [What was validated/tested]

### In Progress
- [What's partially done]
- [What state it's in]

### Next Steps
1. [Specific next action with file reference]
2. [Following action]
3. [Any cleanup or testing needed]

### Issues/Blockers
- [Any problems encountered]
- [Any questions that need answering]
```

## When to Use This

- Context usage above 80%
- Before manually compacting conversation
- End of work session when you want to pause
- Before switching to a different feature

## Example Usage

User: "/dev-docs-update"

You:
1. Find active task in ~/git/project/dev/active/websocket-notifications/
2. Update context.md with recent decisions and next steps
3. Mark completed tasks in tasks.md
4. Confirm what was updated
5. Advise user they can compact and continue next session
