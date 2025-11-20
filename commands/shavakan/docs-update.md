---
description: Update feature context and tasks before compaction
---

# Update Feature Context

Update existing feature context files (context.md, tasks.md) to preserve current state before compaction or break point.

## Additional Instructions

$ARGUMENTS

---

## Objective

Update existing feature context files to preserve current state. Add recent progress and decisions to context.md, mark completed tasks in tasks.md, document next steps for continuation.

**Use when:**
- Approaching token limit (compaction warning)
- Before long pause (end of day/week)
- After significant architectural decisions
- When switching to different feature

---

## Execution

### Phase 1: Locate and Backup

Find existing feature directory in `features/[task-name]/`. If multiple exist or none found, ask user which feature to update.

Create timestamped backups before modifying:
- `context.md.backup-[timestamp]`
- `tasks.md.backup-[timestamp]`

**Gate**: Feature directory located and backups created successfully.

### Phase 2: Review Updates

Present what will be updated:
```
Update feature context files?

□ Update both - context.md + tasks.md
□ Context only - Add progress and decisions
□ Tasks only - Mark completed tasks
□ Review first - Show current state before updating
□ Cancel
```

**Gate**: User must confirm which files to update.

### Phase 3: Apply Updates

**For context.md:**
- Update timestamp to current date/time
- Add Recent Progress section (Completed, In Progress, Next Steps, Issues/Blockers)
- Add new files to Key Files section
- Add architectural decisions with rationale
- Update integration points if dependencies changed

**For tasks.md:**
- Update timestamp to current date/time
- Mark completed tasks (change `- [ ]` to `- [x]`)
- Add new tasks discovered during work
- Reorder if priorities changed

Include specific file references and actionable next steps.

**Gate**: All updates applied successfully with no syntax errors.

### Phase 4: Validate and Report

Verify updates meet quality standards:
- Timestamps current
- Recent Progress section complete with Next Steps
- At least one task marked complete or new task added
- No unclosed code blocks or syntax errors

If validation passes, remove backup files. If validation fails, restore from backups.

Report what was updated: files modified, completed tasks count, next steps documented

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
