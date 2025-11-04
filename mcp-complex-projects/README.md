# mcp-complex-projects

Task management, cognitive tools, and up-to-date documentation for complex project work.

## MCP Servers Included

### taskmaster-ai
AI-powered task management with subtasks, priorities, and intelligent task breakdown.

**Required Environment Variables:**
- `ANTHROPIC_API_KEY` - Your Anthropic API key
- `OPENAI_API_KEY` - Your OpenAI API key

### sequential-thinking
Step-by-step reasoning for complex problems requiring explicit logical flow.

### time
Current time and timezone conversion using IANA timezone names.

**Requirements:** Python (uvx)

### context7
Up-to-date code documentation fetched directly from source repositories. Eliminates hallucinated APIs and outdated guidance.

**Optional Environment Variable:**
- `CONTEXT7_API_KEY` - Enables higher rate limits and private repository access (optional for basic usage)

## Installation

```bash
/plugin install mcp-complex-projects@shavakan
```

## Environment Setup

Add to your shell profile:

```bash
export ANTHROPIC_API_KEY="your-key-here"
export OPENAI_API_KEY="your-key-here"
export CONTEXT7_API_KEY="your-key-here"  # Optional
```

## Usage

**taskmaster-ai**: "Break down this feature into subtasks with priorities"
**sequential-thinking**: "Analyze the tradeoffs between microservices vs monolith"
**context7**: "use context7 Show me Next.js 15 server-side rendering"
**time**: "What time is 2pm PST in Tokyo?"
