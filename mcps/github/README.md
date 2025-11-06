# mcp-github

GitHub repository, issue, and pull request management via MCP.

## MCP Server Included

### github
Official GitHub MCP server for repository operations, issue tracking, and PR management.

**Required Environment Variable:**
- `GITHUB_PERSONAL_ACCESS_TOKEN` - GitHub Personal Access Token with appropriate scopes

**Requirements:** Docker

## Installation

```bash
/plugin install mcp-github@shavakan
```

## Environment Setup

Create a GitHub Personal Access Token with required scopes and add to your shell profile:

```bash
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_your_token_here"
```

## Usage

"Create an issue for this bug with reproduction steps"
"List all open PRs for this repository"
"Show me the file contents of src/main.py from the main branch"
"Search for issues mentioning authentication"
