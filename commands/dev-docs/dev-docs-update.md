---
description: Update dev docs context and tasks before compaction
---

# Dev Docs Update - Pre-Compaction Context Preservation

You are about to run out of context and the conversation will be compacted. Before that happens, you need to preserve the current state so work can continue seamlessly in the next session.

---

## Step 0: Detect Dev Docs Location

**Run the detection script:**

```bash
# Get the plugin root (where scripts are located)
PLUGIN_ROOT="$HOME/.claude/plugins/marketplaces/shavakan"

# Run dev-docs finder script
eval $("$PLUGIN_ROOT/commands/dev-docs/scripts/find-dev-docs.sh")
```

**The script will:**
1. Check `.claude/dev-docs-config` for configured path
2. Try common locations (~/git/project/dev/active, ./dev/active, ./docs/dev, ./.dev-docs)
3. Find active task directories
4. Validate task structure (plan.md, context.md, tasks.md exist)
5. Export environment variables: `DEV_DOCS_DIR`, `TASK_DIR`, `TASK_NAME`, `PLAN_FILE`, `CONTEXT_FILE`, `TASKS_FILE`

**If script fails:**
- Exit code 1: Dev docs directory not found → Run /shavakan-commands:dev-docs first
- Exit code 2: No active tasks or multiple tasks found → Specify task with `--task=NAME`
- Exit code 3: Task structure incomplete → Regenerate with /shavakan-commands:dev-docs

**If script succeeds:**
- All file paths are now set in environment
- Proceed to Step 1

---

## Step 1: Create Safety Backups

```bash
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
cp "$CONTEXT_FILE" "$CONTEXT_FILE.backup-$TIMESTAMP"
cp "$TASKS_FILE" "$TASKS_FILE.backup-$TIMESTAMP"

# Store backup paths for rollback
CONTEXT_BACKUP="$CONTEXT_FILE.backup-$TIMESTAMP"
TASKS_BACKUP="$TASKS_FILE.backup-$TIMESTAMP"
```

---

## Step 2: Update context.md

### 2a. Read Current Content

```bash
cat "$CONTEXT_FILE"
```

### 2b. Required Updates

**1. Update timestamp at top:**
```markdown
**Last Updated:** $(date '+%Y-%m-%d %H:%M:%S')
```

**2. Add/update Recent Progress section:**

Use the template at `$PLUGIN_ROOT/commands/dev-docs/templates/context-update-template.md` as a guide:

```markdown
## Recent Progress (Updated: $(date '+%Y-%m-%d %H:%M:%S'))

### Completed
- [Specific accomplishment with file reference]
- [What was validated/tested]

### In Progress
- [What's partially done]
- [Current state - be specific]

### Next Steps
1. [Exact next action with file:line reference]
2. [Following action with context]
3. [Any cleanup or testing needed]

### Issues/Blockers
- [Specific problem with reproduction steps]
- [Questions needing answers before proceeding]
```

**3. Update Key Files section:**
- Add any new files discovered during work
- Format: `- path/to/file.ts - Purpose and why it matters`

**4. Update Architectural Decisions:**
```markdown
## Architectural Decisions

[N]. **Decision:** [What was decided]
   **Rationale:** [Why we decided it]
   **Impact:** [What it affects]
   **Date:** $(date '+%Y-%m-%d')
```

**5. Update Integration Points:**
- Add any new dependencies or data flows discovered

### 2c. Write Updated Content

Use Edit tool to update `$CONTEXT_FILE` with changes.

---

## Step 3: Update tasks.md

### 3a. Read Current Content

```bash
cat "$TASKS_FILE"
```

### 3b. Required Updates

**1. Update timestamp:**
```markdown
**Last Updated:** $(date '+%Y-%m-%d %H:%M:%S')
```

**2. Mark completed tasks:**
- Change `- [ ]` to `- [x]` for FULLY completed items
- Leave unchecked if partially done (note in context.md instead)

**3. Add new tasks discovered:**
```markdown
- [ ] [New task description with file:path]
```

**4. Reorder if priorities changed**

### 3c. Write Updated Content

Use Edit tool to update `$TASKS_FILE`.

---

## Step 4: Validation

### 4a. Validate Context

```bash
# Check timestamp updated
grep "Last Updated:" "$CONTEXT_FILE" | grep "$(date '+%Y-%m-%d')"

# Check Recent Progress exists
grep "## Recent Progress" "$CONTEXT_FILE"

# Check Next Steps has content
grep -A 3 "### Next Steps" "$CONTEXT_FILE" | grep "^1\."
```

**If any check fails:** Restore from backup and report error.

### 4b. Validate Tasks

```bash
# Check timestamp updated
grep "Last Updated:" "$TASKS_FILE" | grep "$(date '+%Y-%m-%d')"

# Count completed tasks
grep -c "^- \[x\]" "$TASKS_FILE"
```

**If no changes:** Confirm with user that nothing was accomplished.

### 4c. Check Markdown Syntax

```bash
# Check for unclosed code blocks
CODE_BLOCKS=$(grep -c "^\`\`\`" "$CONTEXT_FILE")
if [ $((CODE_BLOCKS % 2)) -ne 0 ]; then
  echo "ERROR: Unclosed code block in context.md"
fi
```

**If syntax errors:** Fix before proceeding.

---

## Step 5: Cleanup & Report

### 5a. Remove Backups (if validation passed)

```bash
rm "$CONTEXT_BACKUP" "$TASKS_BACKUP"
```

### 5b. Generate Summary Report

```markdown
✓ Updated dev docs in $TASK_DIR

**Context Updates:**
- [List specific changes made to context.md]
- [E.g., "Added decision about WebSocket error handling"]
- [E.g., "Noted new key file: src/websocket/manager.ts"]
- Next steps: [First item from Next Steps section]

**Task Updates:**
- Marked complete: [List completed task descriptions]
- Added new tasks: [List new tasks if any]
- Remaining tasks: [Count unchecked tasks]

**Validation:** ✓ All checks passed
**Backup Status:** Backups removed (updates saved successfully)

**Status:** Ready for compaction. Next session should start with "continue $TASK_NAME" and read:
- $CONTEXT_FILE (for recent progress and next steps)
- $TASKS_FILE (for remaining work)
```

---

## Rollback Procedure

If ANY step fails after backups created:

```bash
# Restore original files
cp "$CONTEXT_BACKUP" "$CONTEXT_FILE"
cp "$TASKS_BACKUP" "$TASKS_FILE"

# Remove backups
rm "$CONTEXT_BACKUP" "$TASKS_BACKUP"
```

Report:
```
ROLLBACK: Updates reverted due to [specific error]

Files restored to pre-update state. Fix the issue and retry.
```

---

## Quality Guidelines

### Context.md Quality Standards

**Required:**
- Timestamp reflects current date/time
- Recent Progress section with all 4 subsections
- Next Steps numbered 1-3 minimum with file references
- No vague language ("fix the bug" → "Fix null pointer in websocket/manager.ts:145")

**Optional but Recommended:**
- Code snippets for complex decisions
- Links to relevant docs/issues
- Performance notes if applicable

### Tasks.md Quality Standards

**Required:**
- Timestamp reflects current date/time
- Completed tasks marked with [x]
- At least one change made (completion or addition)

**Optional but Recommended:**
- Estimated time for remaining tasks
- Dependencies noted between tasks
- Risk flags for high-impact tasks

---

## When to Use This Command

**Required before:**
- Context usage above 80%
- Manual conversation compaction
- Long pause in work (end of day/week)

**Recommended before:**
- Switching to different feature
- Major architectural decision made
- Significant blockers encountered

**Not needed if:**
- Just started working (<20% context used)
- No progress made this session
- About to complete entire feature
