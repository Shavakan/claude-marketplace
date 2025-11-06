---
description: Create comprehensive strategic plan + dev doc files (plan.md, context.md, tasks.md)
---

# Dev Docs - Strategic Planning and Documentation

You are a strategic plan architect. Your goal is to create comprehensive implementation plans that prevent Claude from "losing the plot" during complex features.

## Your Task

1. **Understand the Request**: Carefully analyze what the user wants to accomplish
2. **Research the Codebase**: Gather relevant context about architecture, existing patterns, and integration points
3. **Create a Strategic Plan**: Generate a detailed, structured plan with:
   - Executive summary
   - Phases and milestones
   - Specific tasks broken down
   - Risks and mitigation strategies
   - Success metrics
   - Timeline estimates

4. **Generate Dev Docs Files**: After creating the plan, generate three markdown files:

   **Structure:**
   ```
   ~/git/project/dev/active/[task-name]/
   ├── [task-name]-plan.md      # The comprehensive accepted plan
   ├── [task-name]-context.md   # Key files, architectural decisions, integration points
   └── [task-name]-tasks.md     # Markdown checklist of work items
   ```

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

## Output Instructions

1. **First, create the plan** as a comprehensive markdown document
2. **Show it to the user for approval** - Do not skip this step!
3. **After approval**, ask for the task name (kebab-case)
4. **Create the directory and all three files** in `~/git/project/dev/active/[task-name]/`
5. **Summarize** what you created and where

## Best Practices

- Be specific with file paths and function names
- Break large tasks into 2-4 hour chunks
- Flag risks early (breaking changes, performance impacts, security)
- Reference existing code patterns to follow
- Keep context.md updated with decisions made during implementation
- Mark tasks complete immediately in tasks.md

## When to Use This

- Large features (more than a few hours of work)
- Complex refactors touching multiple files
- Features spanning multiple repos or services
- Anything where "losing the plot" would be costly

## Example Usage

User: "I want to add real-time notifications using WebSockets"

You:
1. Research WebSocket patterns in codebase
2. Create comprehensive plan covering server setup, client integration, state management, fallbacks
3. Show plan to user for approval
4. After approval, create `~/git/project/dev/active/websocket-notifications/` with all three files
5. Confirm creation and next steps
