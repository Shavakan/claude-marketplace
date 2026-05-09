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
    "shavakan-skills@shavakan",
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
Multi-hook plugin for skill/agent auto-activation, build checking, and POSIX compliance.

**Hooks:**
1. **Skill/Agent Auto-Activation** (UserPromptSubmit): Analyzes prompts and suggests relevant skills or agents before execution
2. **Build Checker** (PostToolUse + Stop): Tracks file edits and runs builds for TypeScript, Python, and Go projects
3. **POSIX Newline** (PostToolUse): Adds final newlines to files after Write/Edit/MultiEdit operations

#### shavakan-commands
Slash commands for feature context preservation and LSP-aware repository cleanup.

**Commands:**
1. **`/shavakan-commands:docs-feature-plan`** - Create feature plan files (plan.md, context.md, tasks.md)
2. **`/shavakan-commands:docs-save-context`** - Save context before compaction (context.md, tasks.md)
3. **`/shavakan-commands:docs-update`** - Update feature context and tasks
4. **`/shavakan-commands:docs-readme`** - Generate/update condensed developer README
5. **`/shavakan-commands:cleanup`** - Full repository audit and cleanup
6. **`/shavakan-commands:cleanup-dead-code`** - Remove unused code
7. **`/shavakan-commands:cleanup-comments`** - Remove comment noise
8. **`/shavakan-commands:cleanup-docs`** - Sync documentation with code
9. **`/shavakan-commands:cleanup-architecture`** - Refactor code structure
10. **`/shavakan-commands:cleanup-deps`** - Clean up dependencies
11. **`/shavakan-commands:cleanup-duplication`** - Remove code duplication
12. **`/shavakan-commands:code-review`** - Iterative code review cycle with auto-fix

Cleanup commands prefer LSP MCP tools (`find_references`, `document_symbols`, `call_hierarchy_*`, `diagnostics`) when available, with graceful fallback to grep + language linters.

#### shavakan-agents
Specialized agents for code review and development workflows.

**Agents:**
1. **code-reviewer** - Reviews code changes for security vulnerabilities, correctness bugs, architecture violations, and hygiene issues. Use after completing significant code changes or before creating pull requests.

### MCP Server Plugins

#### mcp-infra
Infrastructure as code and package management with Terraform and NixOS.

**Servers:** terraform, nixos

```bash
/plugin install mcp-infra@shavakan
```

#### mcp-github
GitHub repository, issue, and pull request management with PR review analysis.

**Servers:** github

**Commands:**
- `/mcp-github:pr-review-analyze` - Analyze PR review comments and generate fix summary

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

Skills follow a progressive-disclosure layout: lean SKILL.md for activation, with bundled `scripts/`, `references/`, and `templates/` loaded on demand.

### git-commit
Create clean, technical git commit messages focused on code changes rather than project milestones.

**Activates when:** User requests git commit creation

**Key features:**
- Bundled `scripts/group-changes.sh` produces a deterministic commit-grouping plan (JSON) — categorizes files by path/extension, suggests commit order (types → config → code → test → doc), leaves Fix/Feature/Refactor refinement to the model
- No attribution footers or "Generated with Claude" messages
- Focus on technical modifications, not progress language
- 1-2 sentence messages describing code changes

### prompt-engineer
Build, analyze, and optimize LLM prompts with brutal efficiency.

**Activates when:** User wants to create, modify, review, or improve prompts

**Key features:**
- Lean SKILL.md (~80 lines) with on-demand bundled material:
  - `references/anti-patterns.md` — loaded when reviewing existing prompts
  - `references/patterns.md` — loaded when constructing new prompts
  - `references/models.md` — loaded for model-specific or migration questions
  - `templates/prompt-skeleton.md`, `templates/few-shot-skeleton.md` — drafting scaffolds
- Restricted to Read, Write, Edit, WebFetch tools only

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
- Bundled reference catalogs loaded on demand (paired smell + concrete fix):
  - `references/security.md` — injection, auth, secrets, crypto, network
  - `references/correctness-and-reliability.md` — null/edge cases, concurrency, resource management, error handling
  - `references/architecture-smells.md` — god objects, circular deps, layering, premature abstraction
  - `references/performance-and-observability.md` — N+1, complexity, telemetry gaps, caching
- Automatic hygiene fixes (removes obvious comments, cleans outdated docs)
- Structured priority reporting (Critical / High / Medium)

**Review protocol:**
1. Checks working directory state (if clean: runs `git pull --rebase` then compares to main/master)
2. Reads all changed files
3. Loads only the reference files relevant to the change surface
4. Analyzes codebase patterns to detect violations
5. Applies hygiene fixes immediately
6. Reports findings with concrete fixes

**Output format:** Structured report with file:line references, issue types, impacts, and fixes

---

## Commands (in shavakan-commands plugin)

### Feature Context Workflow

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

#### /shavakan-commands:docs-readme
Generate or update a condensed developer README at the project root. Detects build system (Nix/Make/package manager), env management (direnv/.env), and project type, then composes a < 200-line scannable README.

### Repository Cleanup

Structured cleanup commands with phases, gates, and friendly menu UIs. All commands follow speckit-style structured processes with safety constraints.

**Detection strategy** (Phase 0 in each command):
1. Run bundled `commands/cleanup/scripts/probe-tooling.sh` for a JSON capability matrix of locally installed linters, structural analyzers, and complexity tools.
2. Cross-reference with LSP MCP availability (`find_references`, `document_symbols`, `call_hierarchy_*`, `diagnostics`) — preferred when present.
3. Fall back to language linters → grep, with explicit confidence labeling in the audit header.

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

### Code Review

#### /shavakan-commands:code-review
Iterative code review cycle that runs until clean. Uses `shavakan-agents:code-reviewer` to find issues, fixes them automatically, then re-reviews until no actionable issues remain.

- Max 5 iterations to prevent infinite loops
- Addresses all priorities: 🔴 Critical, 🟠 High, 🟡 Medium
- Reports structured summary at end with issues found/fixed per iteration
- Requires `shavakan-agents` plugin (prompts to install if missing)

---

## Acknowledgements

Workflow patterns inspired by [Claude Code is a Beast – Tips from 6 Months of Hardcore Use](https://www.reddit.com/r/ClaudeAI/comments/1oivjvm/claude_code_is_a_beast_tips_from_6_months_of/) by u/JokeGold5455.
