# Shavakan's Claude Marketplace

[![Test](https://github.com/Shavakan/claude-marketplace/actions/workflows/test.yml/badge.svg)](https://github.com/Shavakan/claude-marketplace/actions/workflows/test.yml)

Personal marketplace for Claude Code, focusing on concise, technical workflows.

## Installation

**Add Marketplace:**
```bash
/plugin marketplace add Shavakan/claude-marketplace
```

**Install Plugins:**
```bash
# Skills plugin
/plugin install shavakan-skills@shavakan

# Hooks plugin
/plugin install shavakan-hooks@shavakan

# Commands plugin
/plugin install shavakan-commands@shavakan

# Agents plugin
/plugin install shavakan-agents@shavakan
```

Or browse and install via Claude Code UI after adding the marketplace.

## Enable Per-Project

Add plugins to `.claude/settings.json` in your project:

```json
{
  "enabledPlugins": [
    "mcp-complex-projects@shavakan",
    "shavakan-mcp-github@shavakan"
  ]
}
```

Omit `enabledPlugins` to disable all plugins for simple projects.

---

## Plugins

### Skills & Hooks

#### shavakan-skills
Personal skill collection for specialized workflows.

#### shavakan-hooks
Multi-hook plugin for skill auto-activation, build checking, and POSIX compliance.

**Hooks:**
1. **Skill Auto-Activation** (UserPromptSubmit): Analyzes prompts and suggests relevant skills before execution
2. **Build Checker** (PostToolUse + Stop): Tracks file edits and runs builds for TypeScript, Python, and Go projects
3. **POSIX Newline** (PostToolUse): Adds final newlines to files after Write/Edit/MultiEdit operations

#### shavakan-commands
Slash commands for feature planning, context preservation, and repository cleanup.

**Commands:**
1. **`/shavakan-commands:dev-docs`** - Create comprehensive strategic plan + dev doc files
2. **`/shavakan-commands:dev-docs-update`** - Update dev docs context/tasks before compaction
3. **`/shavakan-commands:dev-docs-readme`** - Generate/update condensed developer README
4. **`/shavakan-commands:docs-feature-plan`** - Create feature plan files (plan.md, context.md, tasks.md)
5. **`/shavakan-commands:docs-save-context`** - Save context before compaction (context.md, tasks.md)
6. **`/shavakan-commands:docs-update`** - Update feature context and tasks
7. **`/shavakan-commands:cleanup`** - Full repository audit and cleanup
8. **`/shavakan-commands:cleanup-dead-code`** - Remove unused code
9. **`/shavakan-commands:cleanup-comments`** - Remove comment noise
10. **`/shavakan-commands:cleanup-docs`** - Sync documentation with code
11. **`/shavakan-commands:cleanup-architecture`** - Refactor code structure
12. **`/shavakan-commands:cleanup-deps`** - Clean up dependencies
13. **`/shavakan-commands:cleanup-duplication`** - Remove code duplication

#### shavakan-agents
Specialized agents for code review and development workflows.

**Agents:**
1. **code-reviewer** - Reviews code changes for security vulnerabilities, correctness bugs, architecture violations, and hygiene issues. Use after completing significant code changes or before creating pull requests.

### MCP Server Plugins

#### mcp-complex-projects
Task management, cognitive tools, and up-to-date documentation for complex project work.

**Servers:** taskmaster-ai, sequential-thinking, time, context7

```bash
/plugin install mcp-complex-projects@shavakan
```

#### mcp-infra
Infrastructure as code and package management with Terraform and NixOS.

**Servers:** terraform, nixos

```bash
/plugin install mcp-infra@shavakan
```

#### shavakan-mcp-github
GitHub repository, issue, and pull request management with PR review analysis.

**Servers:** github

**Commands:**
- `/shavakan-mcp-github:pr-review-analyze` - Analyze PR review comments and generate fix summary

```bash
/plugin install shavakan-mcp-github@shavakan
```

#### mcp-gdrive
Google Drive integration for file and document access.

**Servers:** gdrive

```bash
/plugin install mcp-gdrive@shavakan
```

#### mcp-notion
Notion workspace integration (HTTP-based, no API key needed).

**Servers:** notion

```bash
/plugin install mcp-notion@shavakan
```

---

## Skills (in shavakan-skills plugin)

### git-commit
Create clean, technical git commit messages focused on code changes rather than project milestones.

**Activates when:** User requests git commit creation

**Key features:**
- No attribution footers or "Generated with Claude" messages
- Focus on technical modifications, not progress language
- 1-2 sentence messages describing code changes

### prompt-engineer
Build, analyze, and optimize LLM prompts with brutal efficiency.

**Activates when:** User wants to create, modify, review, or improve prompts

**Key features:**
- Actionable analysis checklist with fixes
- Anti-patterns and validation process
- Model-specific guidance (Haiku/Sonnet/Opus)
- Token efficiency optimization
- Restricted to Read, Write, Edit, WebFetch tools only

### sequential-thinking
For atypically complex problems requiring explicit step-by-step reasoning.

**Activates when:** Problem complexity justifies MCP overhead

**Key features:**
- Autonomously assesses if sequential-thinking adds value
- Silent decision - only invokes if explicit step tracking helps
- Use for multi-layered decisions, circular dependencies, high-stakes reasoning
- Skip for straightforward linear debugging

## Philosophy

All skills follow these principles:
- Brutally concise output - no fluff, no praise
- Focus on technical accuracy over validation
- Direct feedback with concrete fixes
- Question assumptions, flag edge cases

---

## Agents (in shavakan-agents plugin)

### code-reviewer

Reviews code changes with focus on real problems that affect users or developers.

**Use after:** Completing significant code changes or before creating pull requests

**Key features:**
- Security vulnerability detection (SQL injection, XSS, command injection, path traversal)
- Correctness bug identification (null pointer errors, race conditions, resource leaks)
- Architecture violation flagging (god objects, circular dependencies, pattern deviations)
- Automatic hygiene fixes (removes obvious comments, cleans outdated docs)
- Structured priority reporting (Critical/High/Medium)

**Review protocol:**
1. Reads all changed files
2. Analyzes codebase patterns to detect violations
3. Identifies issues by priority
4. Applies hygiene fixes immediately
5. Reports findings with concrete fixes

**Output format:** Structured report with file:line references, issue types, impacts, and fixes

---

## Commands (in shavakan-commands plugin)

### Dev Docs Workflow (Legacy)

Maintains persistent context in `dev/active/` directory.

#### /shavakan-commands:dev-docs
Create comprehensive strategic plan + dev doc files in `dev/active/[task-name]/`.

#### /shavakan-commands:dev-docs-update
Update existing dev docs context and tasks before compaction.

#### /shavakan-commands:dev-docs-readme
Generate or update condensed developer README for project usage and contribution.

### Feature Context Workflow (New)

Prevents context loss during complex features by maintaining files in `features/` directory.

#### /shavakan-commands:docs-feature-plan
Create feature plan files after research and approval.

- Researches codebase and creates detailed implementation plan
- Generates three files after approval:
  - `plan.md` - Complete implementation plan
  - `context.md` - Key files, decisions, integration points
  - `tasks.md` - Checklist of work items
- Files saved to `features/[task-name]/`

#### /shavakan-commands:docs-save-context
Save context state before compaction or natural break points.

- Extracts decisions made during current session
- Documents current progress and what's left
- Creates or updates context.md and tasks.md
- Use when approaching token limit or before pausing work

#### /shavakan-commands:docs-update
Update existing feature context files.

- Updates timestamps and recent progress
- Marks completed tasks
- Documents next steps for continuation
- Creates safety backups before modifying

**Usage pattern:**
1. Start: `/shavakan-commands:docs-feature-plan` → approve → files created in `features/`
2. During work: Mark tasks complete as you finish them
3. Before compaction: `/shavakan-commands:docs-save-context` or `/shavakan-commands:docs-update`
4. Resume: Read feature docs, continue

**Use for:** Large features, complex refactors, multi-repo work, anything where losing context is costly

### Repository Cleanup

Structured cleanup commands with phases, gates, and friendly menu UIs. All commands follow speckit-style structured processes with safety constraints.

#### /shavakan-commands:cleanup
Full repository audit and cleanup. Scans all categories (dead code, comments, docs, architecture, deps, duplication), presents comprehensive findings, then orchestrates cleanup subcommands based on user priorities.

#### /shavakan-commands:cleanup-dead-code
Remove unused imports, functions, variables, commented blocks, unreachable code, and unused files. Menu-driven selection with test verification after each category.

#### /shavakan-commands:cleanup-comments
Remove obvious comments and comment noise. Refactors code to be self-documenting before removing comments. Keeps "why" explanations, removes "what" descriptions.

#### /shavakan-commands:cleanup-docs
Sync documentation with code. Fixes dead links, updates API docs, removes outdated content, corrects file paths, and adds missing documentation.

#### /shavakan-commands:cleanup-architecture
Refactor code structure. Splits god objects, breaks circular dependencies, improves separation of concerns, reduces complexity. Risk-based menu for safe refactoring.

#### /shavakan-commands:cleanup-deps
Clean up dependencies. Removes unused packages, fixes security vulnerabilities, updates outdated dependencies, deduplicates versions. Conservative/moderate/aggressive strategies.

#### /shavakan-commands:cleanup-duplication
Remove code duplication. Extracts duplicated blocks, consolidates functions, extracts magic values to constants, unifies similar patterns. Follows "Rule of Three" before extraction.

---

## Acknowledgements

Workflow patterns inspired by [Claude Code is a Beast – Tips from 6 Months of Hardcore Use](https://www.reddit.com/r/ClaudeAI/comments/1oivjvm/claude_code_is_a_beast_tips_from_6_months_of/) by u/JokeGold5455.
