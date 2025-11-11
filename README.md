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
```

Or browse and install via Claude Code UI after adding the marketplace.

## Enable Per-Project

Add plugins to `.claude/settings.json` in your project:

```json
{
  "enabledPlugins": [
    "mcp-complex-projects@shavakan",
    "mcp-github@shavakan"
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
Slash commands for dev docs workflow and repository cleanup.

**Commands:**
1. **`/shavakan.dev-docs`** - Create comprehensive strategic plan + dev doc files
2. **`/shavakan.dev-docs-update`** - Update context/tasks before compaction
3. **`/shavakan.cleanup`** - Full repository audit (dead code, comments, docs, architecture, deps)
4. **`/shavakan.cleanup.dead-code`** - Remove unused code only
5. **`/shavakan.cleanup.comments`** - Remove comment noise only
6. **`/shavakan.cleanup.docs`** - Sync documentation only
7. **`/shavakan.cleanup.architecture`** - Refactor structure only
8. **`/shavakan.cleanup.deps`** - Clean dependencies only

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

#### mcp-github
GitHub repository, issue, and pull request management.

**Servers:** github

```bash
/plugin install mcp-github@shavakan
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

## Commands (in shavakan-commands plugin)

### Dev Docs Workflow

Prevents Claude from "losing the plot" during complex features by maintaining persistent context across compactions.

#### /shavakan.dev-docs
Create comprehensive strategic plan + dev doc files.

- Researches codebase and creates detailed implementation plan
- Generates three files after approval:
  - `[task-name]-plan.md` - Complete implementation plan
  - `[task-name]-context.md` - Key files, decisions, integration points
  - `[task-name]-tasks.md` - Checklist of work items
- Files saved to `~/git/project/dev/active/[task-name]/`

#### /shavakan.dev-docs-update
Update context/tasks before compaction.

- Updates context.md with recent decisions and next steps
- Marks completed tasks in tasks.md
- Preserves state for seamless continuation

**Usage pattern:**
1. Start: `/shavakan.dev-docs` → approve → files created
2. During work: Update tasks as you complete
3. Before compaction: `/shavakan.dev-docs-update`
4. Resume: Read dev docs, continue

**Use for:** Large features, complex refactors, multi-repo work, anything where losing context is costly

### Repository Cleanup

Comprehensive cleanup commands for code quality, dead code, documentation, architecture, and dependencies.

#### /shavakan.cleanup
Full repository audit and cleanup. Scans for dead code, comment noise, documentation rot, architecture smells, dependency issues, and file organization problems. Then executes improvements based on user priorities.

#### /shavakan.cleanup.dead-code
Remove unused imports, functions, variables, commented blocks, unreachable code, and unused files. Focused cleanup with test verification.

#### /shavakan.cleanup.comments
Remove obvious comments and comment noise. Refactors code to be self-documenting before removing comments. Keeps "why" explanations, removes "what" descriptions.

#### /shavakan.cleanup.docs
Sync documentation with code. Fixes dead links, updates API docs, removes outdated content, corrects file paths, and adds missing documentation.

#### /shavakan.cleanup.architecture
Refactor code structure. Splits god objects, breaks circular dependencies, improves separation of concerns, reduces complexity.

#### /shavakan.cleanup.deps
Clean up dependencies. Removes unused packages, fixes security vulnerabilities, updates outdated dependencies, deduplicates versions

---

## Acknowledgements

Workflow patterns inspired by [Claude Code is a Beast – Tips from 6 Months of Hardcore Use](https://www.reddit.com/r/ClaudeAI/comments/1oivjvm/claude_code_is_a_beast_tips_from_6_months_of/) by u/JokeGold5455.
