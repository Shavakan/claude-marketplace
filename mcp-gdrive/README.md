# mcp-gdrive

Google Drive integration for file and document access via MCP.

## MCP Server Included

### gdrive
Access and manage Google Drive files and folders with automatic format conversion (Docs to Markdown, Sheets to CSV, Slides to text).

**Required Environment Variable:**
- `GOOGLE_DRIVE_OAUTH_CREDENTIALS` - Path to Google OAuth credentials JSON file

## Installation

```bash
/plugin install mcp-gdrive@shavakan
```

## Setup

1. Create a Google Cloud project and enable Google Drive API
2. Create OAuth 2.0 credentials (Desktop app type)
3. Download the credentials JSON file
4. Add environment variable to your shell profile:

```bash
export GOOGLE_DRIVE_OAUTH_CREDENTIALS="$HOME/.config/google-drive/gcp-oauth.keys.json"
```

5. On first use, you'll be prompted to authorize access via browser
6. Tokens auto-refresh, no re-authentication needed

## Usage

"Read the project requirements doc from my Drive"
"Search Drive for files containing 'API specification'"
"Show me the contents of the Q4 planning spreadsheet"
