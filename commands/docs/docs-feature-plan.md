---
description: Create comprehensive strategic plan + context files (plan.md, context.md, tasks.md)
---

# Feature Plan - Strategic Planning and Documentation

Create comprehensive implementation plans that prevent losing context during complex features.

## Objective

Create comprehensive implementation plans for complex features that prevent context loss during development. Research codebase, design strategic plan with phases and risks, generate planning files in features/ directory.

**Output Structure:**
```
features/[task-name]/
├── plan.md      # Comprehensive accepted plan
├── context.md   # Key files, architectural decisions, integration points
└── tasks.md     # Markdown checklist of work items
```

---

## Execution

### Phase 1: Research and Plan

Analyze user requirements and research codebase for architecture, existing patterns, and integration points. Create comprehensive strategic plan including:

- Executive summary (what and why)
- Implementation phases with specific tasks
- Risks and mitigation strategies
- Success metrics and timeline estimates

Reference specific file paths, function names, and existing patterns to follow.

**Gate**: Present complete plan to user for review before creating files.

### Phase 2: Confirm Approach

Present the strategic plan with options:
```
Create feature plan files?

□ Approve plan - Create files in features/ directory
□ Revise approach - Adjust strategy before creating files
□ Change scope - Modify phases or tasks
□ Cancel
```

After approval, ask for task name (kebab-case format).

**Gate**: User must approve plan and provide task name.

### Phase 3: Generate Planning Files

Create `features/[task-name]/` directory with three files:

**plan.md** - Comprehensive implementation plan (executive summary, phases, tasks, risks, success metrics, timeline)

**context.md** - Key files, architectural decisions, integration points, patterns to follow, next steps for resuming work

**tasks.md** - Markdown checklist organized by phase, including testing and documentation tasks

**Gate**: All files created successfully.

### Phase 4: Report Results

Summarize what was created: directory location, files generated, next steps for implementation. Remind user to keep context.md updated during implementation and mark tasks complete in tasks.md.

---

## File Format Examples

### plan.md Format
```markdown
# [Feature Name] Implementation Plan

## Executive Summary
[2-3 sentences describing what and why]

## Context
- Current state
- Why this change is needed
- What problems it solves

## Implementation Phases

### Phase 1: [Name]
**Goal:** [What this phase achieves]

**Tasks:**
1. Task description with file references
2. Another task

**Risks:**
- Risk and mitigation

### Phase 2: [Name]
...

## Success Metrics
- How we know it's working
- What to test

## Timeline
Estimated: X days/weeks
```

### context.md Format
```markdown
# [Feature Name] - Context & Key Decisions

**Last Updated:** [timestamp]

## Key Files
- `path/to/file.ts` - Purpose and why it matters
- `path/to/another.ts` - Purpose

## Architectural Decisions
1. **Decision:** What we decided
   **Rationale:** Why we decided it
   **Impact:** What it affects

2. **Decision:** ...

## Integration Points
- How this feature connects with X
- Dependencies on Y service
- Data flow: A → B → C

## Important Patterns
- Pattern we're using and why
- Existing code to follow as example

## Next Steps
[When resuming work, start here]
```

### tasks.md Format
```markdown
# [Feature Name] - Task Checklist

**Last Updated:** [timestamp]

## Phase 1: [Name]
- [ ] Task 1 description
- [ ] Task 2 description
- [ ] Task 3 description

## Phase 2: [Name]
- [ ] Task 1 description
- [ ] Task 2 description

## Testing
- [ ] Unit tests for X
- [ ] Integration tests for Y
- [ ] Manual testing of Z

## Documentation
- [ ] Update API docs
- [ ] Update README
```

---

## Best Practices

- Be specific with file paths and function names
- Break large tasks into 2-4 hour chunks
- Flag risks early (breaking changes, performance impacts, security)
- Reference existing code patterns to follow
- Keep context.md updated with decisions made during implementation
- Mark tasks complete immediately in tasks.md

## When to Use

- Large features (more than a few hours of work)
- Complex refactors touching multiple files
- Features spanning multiple repos or services
- Anything where losing context would be costly

## Example

User request: "I want to add real-time notifications using WebSockets"

Workflow:
1. Research WebSocket patterns in codebase
2. Create comprehensive plan covering server setup, client integration, state management, fallbacks
3. Show plan to user for approval
4. After approval, create `features/websocket-notifications/` with all three files
5. Confirm creation and next steps
