---
name: git-commit
description: Create git commits with succinct technical messages. Activates when user requests git commit creation.
---

# Git Commit

Create technical commit messages, one per logical unit. Use the bundled grouping script for the deterministic part; spend tokens on Fix/Feature/Refactor refinement and message wording.

## Process

1. **Branch check.** Run `git branch --show-current`. If on `main` / `master` and the user did not explicitly request committing there, create a feature branch first (`feat/<description>` or `fix/<description>`) and switch to it.
2. Run `scripts/group-changes.sh` (default: working tree). Output is JSON:
   - `files[]` — every changed path with `{status, type, top}` where `type ∈ {types, config, code, test, doc}`
   - `groups[]` — pre-bucketed by `(type, top-level dir)`
   - `order[]` — suggested commit sequence (types → config → code → test → doc)
3. **Refine `code` groups.** The script can't tell Fix from Feature from Refactor. For each `type=code` group, read the diff (`git diff -- <files>`) and decide:
   - **Fix** vs **Feature** vs **Refactor** vs **Types** vs **Config** (re-classify if the script guessed wrong)
   - **Split** if one group mixes intents (e.g., a fix and an unrelated refactor in the same dir)
   - **Merge** if two adjacent groups belong together (e.g., type changes + the code consuming them, when tightly coupled and <3 files)
4. **Couple tests with implementation** when implementation + its tests total <3 files. Otherwise commit tests separately, after implementation.
5. **Stage and commit** per refined unit. Use `git add -p` if a single file straddles two units.
6. **Verify** every changed file is staged exactly once across the commit sequence.

## Script invocation

```bash
# Default: full working tree (staged + unstaged + untracked)
$CLAUDE_PLUGIN_ROOT/scripts/group-changes.sh

# Only what's already staged
$CLAUDE_PLUGIN_ROOT/scripts/group-changes.sh --staged-only

# Diff against a ref (PR-style: "everything since branch point")
$CLAUDE_PLUGIN_ROOT/scripts/group-changes.sh --vs=main
```

If `$CLAUDE_PLUGIN_ROOT` isn't set, the script lives at `skills/git-commit/scripts/group-changes.sh` relative to this skill's plugin root.

## Refinement rules

**Coupling boundaries** (one commit):
- Type changes + code that uses them
- Renames + import updates that follow
- Implementation + its tests when <3 files total

**Independence** (separate commits):
- Different modules touched in unrelated ways
- Bug fix + unrelated refactor
- Docs always separate unless trivially coupled to one code change

**Circular deps:** if fix A requires refactor B, commit B first (minimal scope), then A.

## Message guidelines

Describe **what changed in the code**, not progress:

- "Add null checks to user validation"
- "Extract database logic into separate module"
- "Fix memory leak in event handler cleanup"

Avoid milestone language:
- ❌ "Implement user authentication feature"
- ❌ "Continue work on API endpoints"
- ❌ "Add tests and improve code quality"

1-2 sentences. No body unless a non-obvious why.

## Hard rules

- **Never commit directly to `main` / `master`** unless the user explicitly requests it.
- **Never** include `Co-Authored-By: Claude` or `Generated with Claude Code` footers.
- **Never** use heredoc with attribution.
- Default to multiple small commits over one large commit.
- Every changed file staged exactly once across the sequence.
- If >6 commit units, surface the plan and ask before executing.

## Edge cases

- **All changes one logical unit** → one commit; ignore the group split.
- **Mixed intents in a single file** → `git add -p` to stage hunks separately.
- **Script reports `code` for a config-like file** (rare, e.g., custom build script) → manually re-classify; the heuristic is path-based.
- **Renames** → script picks the destination path; rename + edits in same file land in one commit.
