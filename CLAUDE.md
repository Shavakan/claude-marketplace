# Project Scope

This marketplace provides personal productivity plugins for Claude Code.

**Plugin Types:**
- **Skills** - Specialized workflows (git commits, prompt engineering, sequential thinking)
- **Agents** - Autonomous task executors (code review, architecture analysis)
- **Commands** - Slash commands for dev docs and repository cleanup
- **Hooks** - Auto-activation, build checking, POSIX compliance
- **MCP Servers** - Third-party integrations (GitHub, Notion, Google Drive, etc.)

**Philosophy:**
- Brutally concise output - no fluff, no praise
- Focus on technical accuracy over validation
- Direct feedback with concrete fixes
- Question assumptions, flag edge cases

**Structure:**
```
claude-marketplace/
├── skills/          # Skill plugins
├── agents/          # Agent plugins
├── commands/        # Slash command plugins
├── hooks/           # Hook plugins
└── mcps/            # MCP server plugins
```

---

# Spec Compliance

Hooks plugins require `"hooks"` field in plugin.json.
MCP plugins require `"mcpServers"` field in plugin.json.
Skills plugins require `"skills"` array in plugin.json.
Agents plugins require `"agents"` array in plugin.json.
Commands plugins auto-discover from `commands/` directory (optional `"commands"` field for custom paths).

## Common Pitfalls

**Author field must be object, not string:**
```json
✅ "author": { "name": "shavakan", "email": "cs.changwon.lee@gmail.com" }
❌ "author": "shavakan"
```

## Plugin Updates

When updating a plugin, always bump the version in `plugin.json`:
- Patch version (1.1.1 → 1.1.2) for bug fixes and clarifications
- Minor version (1.1.0 → 1.2.0) for new features
- Major version (1.0.0 → 2.0.0) for breaking changes

Verify compliance before commits.
