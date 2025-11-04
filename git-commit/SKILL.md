---
name: git-commit
description: Create git commits with succinct technical messages. Activates when user requests git commit creation.
---

# Git Commit

## Overview

Create clean, technical git commit messages focused on code changes rather than project milestones.

## Process

1. Run `git status` and `git diff` to analyze changes
2. Draft message describing technical modifications (1-2 sentences max)
3. Add untracked files if relevant
4. Commit with message only - no footers or attribution

## Message Guidelines

**Focus on WHAT changed in the code:**
- "Add null checks to user validation"
- "Extract database logic into separate module"
- "Fix memory leak in event handler cleanup"

**Avoid progress/milestone language:**
- ❌ "Implement user authentication feature"
- ❌ "Continue work on API endpoints"
- ❌ "Add tests and improve code quality"

## Important

- Never include "Co-Authored-By: Claude" or "Generated with Claude Code"
- No heredoc format with attribution footers
- Describe technical change, not project progress
