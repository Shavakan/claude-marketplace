# mcp-notion

Notion workspace integration for notes and documentation access via MCP.

## MCP Server Included

### notion
Official Notion MCP server (HTTP-based) for accessing and managing workspace content.

**No environment variables required** - authentication handled via Notion's OAuth flow.

## Installation

```bash
/plugin install mcp-notion@shavakan
```

## Setup

1. Enable the plugin
2. On first use, you'll be prompted to authenticate with Notion
3. Grant access to desired pages/databases

No API key setup required!

## Usage

"Show me the architecture decisions from our Notion wiki"
"Search Notion for pages about authentication"
"Read the engineering onboarding page"

**Note:** Only has access to pages you explicitly grant during OAuth.
