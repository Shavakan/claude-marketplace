---
description: Update feature context and tasks before compaction
---

# Update Feature Context

Update existing feature context files (context.md, tasks.md) to preserve current state before compaction or break point.

## Objective

Update existing context files in `features/[task-name]/` directory:
- Add recent progress and decisions to context.md
- Mark completed tasks in tasks.md
- Document next steps for continuation

## When to Use

- Approaching conversation token limit (compaction warning)
- Before long pause in work (end of day/week)
- After making significant architectural decisions
- When switching to different feature

---

## Execution

### 1. Locate Feature Context

Find existing feature directory in `features/[task-name]/`. If multiple exist or none found, ask user which feature to update.

### 2. Create Safety Backups

Before modifying files, create timestamped backups:
- `context.md.backup-[timestamp]`
- `tasks.md.backup-[timestamp]`

### 3. Update context.md

Read current content, then update:

**Update timestamp:**
```markdown
**Last Updated:** [current date/time]
```

**Add Recent Progress section:**
```markdown
## Recent Progress (Updated: [timestamp])

### Completed
- [Specific accomplishment with file reference]

### In Progress
- [What's partially done with current state]

### Next Steps
1. [Exact next action with file:line reference]
2. [Following action]

### Issues/Blockers
- [Specific problems or questions]
```

**Update sections as needed:**
- Add new files to Key Files section
- Add architectural decisions with rationale
- Update integration points if dependencies changed

### 4. Update tasks.md

Read current content, then update:

**Update timestamp:**
```markdown
**Last Updated:** [current date/time]
```

**Mark completed tasks:**
- Change `- [ ]` to `- [x]` for completed items
- Add new tasks discovered during work
- Reorder if priorities changed

### 5. Validate and Report

Verify updates:
- Timestamps reflect current date
- Recent Progress section exists with Next Steps
- At least one task marked complete or new task added
- No unclosed code blocks or syntax errors

If validation passes:
- Remove backup files
- Report what was updated and next steps

If validation fails:
- Restore from backups
- Report error and retry

---

## Quality Standards

### context.md Requirements

- Timestamp current
- Recent Progress with all subsections (Completed, In Progress, Next Steps, Issues/Blockers)
- Specific file references (not vague like "fix the bug")
- Clear next steps (numbered, actionable)

### tasks.md Requirements

- Timestamp current
- Completed tasks marked with [x]
- At least one change made
- Tasks have specific descriptions with file paths

---

## Rollback

If any step fails after backups created, restore original files from backups and report error.

---

## Related Commands

- `/shavakan-commands:docs-save-context` - Save context (works without existing files)
- `/shavakan-commands:docs-feature-plan` - Create new feature plan from scratch
