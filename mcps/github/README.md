# shavakan-mcp-github

GitHub repository, issue, and pull request management via MCP with PR review analysis commands.

## MCP Server Included

### github
Official GitHub MCP server for repository operations, issue tracking, and PR management.

**Required Environment Variable:**
- `GITHUB_PERSONAL_ACCESS_TOKEN` - GitHub Personal Access Token with appropriate scopes

**Requirements:** Docker

## Commands Included

### /shavakan-mcp-github:pr-review-analyze
Analyze PR review comments from GitHub (Copilot, human reviewers) and generate a concise fix summary optimized for another Claude Code instance.

**Usage:**
```bash
/shavakan-mcp-github:pr-review-analyze <PR_URL or PR_NUMBER>
```

**What it does:**
1. Fetches PR details and all review comments (prioritizes GitHub MCP, fallback to gh CLI)
2. Categorizes comments by severity (Blocking, High, Medium, Low)
3. Extracts technical details (file paths, line numbers, issues, fixes)
4. Generates concise summary formatted for another Claude Code instance

**Output categories:**
- **Blocking Issues** - Security, logic errors, data corruption (must fix)
- **High Priority** - Performance problems, race conditions (should fix)
- **Medium/Low Priority** - Optimizations, style (optional)

**Requires:**
- Primary: GitHub MCP server with `GITHUB_PERSONAL_ACCESS_TOKEN` configured
- Fallback: GitHub CLI (`gh`) installed and authenticated

## Installation

```bash
/plugin install shavakan-mcp-github@shavakan
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
