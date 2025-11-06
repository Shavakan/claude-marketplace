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

## Acknowledgements

Hook system design inspired by [Claude Code is a Beast – Tips from 6 Months of Hardcore Use](https://www.reddit.com/r/ClaudeAI/comments/1oivjvm/claude_code_is_a_beast_tips_from_6_months_of/) by u/JokeGold5455. The skills auto-activation and build checker hooks implement patterns proven effective in production environments handling 300k+ LOC refactors.
