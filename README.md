# Shavakan's Marketplace

Personal marketplace for Claude Code plugins, focusing on concise, technical workflows.

## Add Marketplace

```bash
claude marketplace add https://github.com/Shavakan/skills
```

## Plugins

### skills
Personal skill collection: prompt engineering, git commits, and sequential thinking.

**Install:**
```bash
claude plugin install skills
```

**Update:**
```bash
claude plugin update skills
```

---

## Available Skills (in `skills` plugin)

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

## License

MIT
