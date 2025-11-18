---
description: Generate/update condensed developer README for project usage and contribution
---

# README Generator

Create/update README.md in project root. **Constraints: < 200 lines, scannable in 30 seconds, technical tone (no marketing).**

## Additional Instructions

$ARGUMENTS

---

## Analysis Phase

Check files in order, record findings:

1. `flake.nix` → Nix flake present (Y/N)
2. `.envrc` + `.envrc.example` → direnv present (Y/N)
3. `Makefile` → Make targets available (Y/N)
4. `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` → Language ecosystem
5. Existing `README.md` → Preserve badges, screenshots, custom sections
6. Entry points → `main.py`, `index.ts`, `cmd/main.go`, etc

## Build System Priority

**Select primary build interface based on presence:**

| Priority | System | When | Commands |
|----------|--------|------|----------|
| 1 | Nix | `flake.nix` exists | `nix develop`, `nix build`, `nix run` |
| 2 | Make | `Makefile` exists | `make install`, `make test`, `make build` |
| 3 | Package manager | `package.json` / `Cargo.toml` | `npm install`, `cargo build` |
| 4 | Direct | None above | `python -m`, `go run`, etc |

**If multiple exist**: Use highest priority as primary, mention others as alternatives.

## Environment Management

**If `.envrc` exists:**
- Prerequisites: Add "direnv" requirement
- Install step: Add `cp .envrc.example .envrc && direnv allow`
- Configuration section: Reference `.envrc.example` for variables

**If no direnv**:
- Use `.env` files or manual `export` commands
- Configuration section: List env vars inline

## README Composition

**Required sections (generate in order):**

### 1. Title + Summary
```
# [Project Name]
> [Single sentence: does X for Y users]
```

### 2. Quick Start

**Prerequisites**: List tools with versions. Omit language version if Nix manages it. Include Nix/direnv if detected.

**Install**: Commands to get dependencies. Prioritize by build system table above.

**Run**: Command to start/execute. Include port/URL for web apps.

**Test**: Command to run tests. Use `nix flake check` if available.

### 3. Project Structure

Tree diagram of key directories with inline comments:
```
src/
  core/       # Business logic
  api/        # Endpoints
tests/        # Test suite
```

### 4. Development

**Setup**: Additional dev steps (direnv, pre-commit hooks, etc)

**Build/Lint/Format**: Commands using primary build system

**Common tasks**: 2-3 bullet points for frequent operations

### 5. Optional Sections (include only if applicable)

**Architecture**: 2-3 sentences on design decisions and tradeoffs. Include if non-obvious.

**Configuration**: Env vars with descriptions. Required vs optional. Include if app needs config.

**Deployment**: Deploy command or link. Include for deployable apps.

**Contributing**: Link to CONTRIBUTING.md or inline if < 5 rules.

**License**: License type. Include if LICENSE file exists.

## Output Format Rules

**Command syntax:**
- Multi-word commands: Always use code blocks, never inline
- Good: "Run:\n```bash\nnpm run dev\n```"
- Bad: "Run `npm run dev`"

**Section length**: Each section < 15 lines. Link to detailed docs if longer.

**Style**: Technical, direct. Explain WHY for architecture, not WHAT code does. No "easy", "simple", "just".

**Preservation**: Keep existing badges, screenshots, unique sections from old README.

## Project Type Adaptations

| Type | Adaptations |
|------|-------------|
| CLI tool | Add "Usage" with examples, omit "Running" |
| Library | Add "Installation" + "Usage" with API examples, omit "Running" |
| Web app | Include PORT/URL in "Run", add "Deployment" |
| Monorepo | Show workspace structure, document per-package commands |
| Nix multi-output | Add `nix flake show` output, document available apps/packages |

## Execution Workflow

1. Run analysis phase → Collect build system, env management, project type
2. Generate README content using composition rules
3. Show preview with summary: "[Project type] with [build system]. README uses [commands]. ~[N] lines."
4. **If approved** → Write to `README.md`
5. **If rejected** → Ask what to change, regenerate from step 2

## Edge Cases

**No build system found**: Use direct language commands (python, go run, etc) and warn in preview.

**Nix without devShell**: Use `nix-shell` or `nix develop` with warnings about flake completeness.

**Multiple entry points**: List all in "Run" section with descriptions.

**Secrets in .envrc**: Never read actual `.envrc`, only `.envrc.example`. Remind about `.gitignore`.

## Example Execution

**Input**: "Generate README"

**Analysis**:
- flake.nix: Yes (Nix development shell + app)
- .envrc: Yes (with .envrc.example)
- Makefile: Yes (install/test/build targets)
- package.json: Yes (Next.js)
- Entry: pages/index.tsx

**Build priority**: Nix (priority 1), mention Make as fallback

**Preview**: "Next.js web app with Nix flake and direnv. README uses `nix run` for primary interface, notes `make` commands as alternative. Includes .envrc.example setup. ~90 lines. Approve?"

**Output**: README.md with Nix-first commands, direnv setup, project structure showing pages/ and components/, development section with `nix build` and `nix flake check`.
