---
description: Save conversation context before compaction (context.md, tasks.md)
---

# Save Context - Pre-Compaction State Preservation

Preserve current conversation state and decisions before approaching token limit or natural break point.

## Objective

Capture conversation state by:
1. Extracting decisions made during current session
2. Documenting current progress and what's left to do
3. Updating or creating context files for continuity across compaction

## When to Use

- Approaching conversation token limit (compaction warning)
- Natural break point in complex feature work
- Before switching contexts or pausing work
- After making important architectural decisions

---

## Execution

### 1. Identify Context Location

Check if feature context already exists:
- Look for existing `features/[task-name]/` directory
- If exists, update existing files
- If not, ask user for task name and create new directory

### 2. Extract Current State

Capture from conversation:

**Decisions made:**
- What was decided and why
- Trade-offs considered
- Alternatives rejected
- Rationale for approach

**Current progress:**
- What's been completed
- What's partially done
- What's blocked and why

**Next steps:**
- Immediate next actions
- Dependencies to resolve
- Open questions

### 3. Update or Create Files

**If updating existing context:**
```
features/[task-name]/
├── context.md   # Append new decisions, update "Next Steps"
└── tasks.md     # Mark completed tasks, update status
```

**If creating new context:**
```
features/[task-name]/
├── context.md   # Current state and decisions
└── tasks.md     # Remaining work checklist
```

Note: plan.md is optional for context saves (only needed for feature-plan)

### 4. Confirm and Summarize

Report what was saved:
- Location of saved files
- Key decisions captured
- Tasks marked complete
- Next steps documented

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
