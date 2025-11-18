---
description: Save conversation context before compaction (context.md, tasks.md)
---

# Save Context - Pre-Compaction State Preservation

Preserve current conversation state and decisions before approaching token limit or natural break point.

## Objective

Preserve conversation state before compaction or natural break points. Extract decisions made, document current progress, update context files for continuity.

**Use when:**
- Approaching token limit (compaction warning)
- Natural break point in complex work
- Before switching contexts
- After important architectural decisions

---

## Execution

### Phase 1: Analyze Current State

Extract from conversation:

**Decisions made** - What was decided and why, trade-offs considered, alternatives rejected, rationale for approach

**Current progress** - What's completed, partially done, blocked (and why)

**Next steps** - Immediate next actions, dependencies to resolve, open questions

Check if feature context already exists in `features/[task-name]/` directory.

**Gate**: Present summary of extracted state to user.

### Phase 2: Confirm Context Strategy

Present options based on whether context files exist:
```
Save context state?

□ Update existing - Append to features/[task-name]/ files
□ Create new - Start fresh context directory
□ Review first - Show extracted state before saving
□ Cancel
```

If creating new, ask for task name (kebab-case format).

**Gate**: User must confirm approach and provide task name if needed.

### Phase 3: Update or Create Files

**If updating existing:**
- Append new decisions to context.md with timestamp
- Update "Next Steps" section
- Mark completed tasks in tasks.md
- Add new tasks if discovered

**If creating new:**
- Create `features/[task-name]/` directory
- Generate context.md with current state and decisions
- Generate tasks.md with remaining work checklist

Note: plan.md not needed for context saves (only for feature-plan command).

**Gate**: All files updated or created successfully.

### Phase 4: Report Results

Summarize what was saved: location of files, key decisions captured, tasks marked complete, next steps documented for resuming work

---

## File Formats

### context.md Format

```markdown
# [Feature Name] - Context

**Last Updated:** [timestamp]

## Current State

[Where we are in implementation - 2-3 sentences]

## Recent Decisions

### [Decision Title]
**What:** What was decided
**Why:** Rationale and trade-offs
**When:** [timestamp]
**Impact:** What this affects

## Key Files

- `path/to/file.ts` - Purpose and current state
- `path/to/another.ts` - What was changed

## Next Steps

[When resuming work, start here - specific actionable items]

## Open Questions

- Question that needs resolution
- Blocker or dependency
```

### tasks.md Format

```markdown
# [Feature Name] - Tasks

**Last Updated:** [timestamp]

## Completed
- [x] Task that was finished
- [x] Another completed task

## In Progress
- [ ] Task currently being worked on (50% done)

## Blocked
- [ ] Task blocked by X dependency

## Todo
- [ ] Next task to do
- [ ] Subsequent task
```

---

## Best Practices

- **Be specific**: Include file paths, function names, line numbers
- **Capture why**: Decisions without rationale lose value
- **Update timestamps**: Always update "Last Updated" field
- **Mark progress**: Move tasks from todo → in progress → completed
- **Note blockers**: Document what's preventing progress and why

---

## Related Commands

- `/shavakan-commands:docs-feature-plan` - Create comprehensive feature plan from scratch
- `/shavakan-commands:docs-update` - Update existing context files
