# mcp-infra

Infrastructure as code and package management with Terraform and NixOS.

## MCP Servers Included

### terraform
Terraform infrastructure management for planning, applying, and managing cloud resources.

**Requirements:** Docker

### nixos
NixOS package search and management for declarative system configuration.

**Requirements:** Python (uvx)

## Installation

```bash
/plugin install mcp-infra@shavakan
```

## Requirements

- Docker (for Terraform MCP)
- Python with uvx (for NixOS MCP)

## Usage

**terraform**: "Show me the terraform plan for this infrastructure change"
**nixos**: "Search for a NixOS package that provides PostgreSQL 16"
