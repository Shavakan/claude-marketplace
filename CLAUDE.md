# Spec Compliance

Hooks plugins require `"hooks"` field in plugin.json.
MCP plugins require `"mcpServers"` field in plugin.json.
Skills plugins require `"skills"` array in plugin.json.
Agents plugins require `"agents"` array in plugin.json.
Commands plugins auto-discover from `commands/` directory (optional `"commands"` field for custom paths).

Verify compliance before commits.
