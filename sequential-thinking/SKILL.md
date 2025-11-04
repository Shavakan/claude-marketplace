---
name: sequential-thinking
description: Use for atypically complex problems requiring explicit step-by-step reasoning. Skill autonomously decides if sequential-thinking MCP overhead is justified based on problem complexity.
---

# Sequential Thinking

## Overview

Use sequential-thinking MCP tool for problems with atypical complexity requiring explicit reasoning paths. The skill autonomously assesses whether MCP overhead provides value.

## When to Consider Sequential-Thinking MCP

Activate this skill for:
- Multi-layered architectural decisions with significant tradeoffs
- Complex debugging across multiple interacting systems
- Problems with circular dependencies or non-obvious root causes
- Design decisions requiring exploration of alternative approaches
- Race conditions, deadlocks, or timing-sensitive bugs
- Performance bottlenecks with unclear origins

## Decision Criteria

**Use sequential-thinking MCP when:**
- Problem requires branching into alternative reasoning paths that should be tracked
- Assumptions need revision as new information emerges
- Multiple interdependent factors must be balanced simultaneously
- High-stakes decision needs documented reasoning trail
- Genuinely uncertain and need systematic exploration

**Skip sequential-thinking MCP when:**
- Problem is complex but straightforward (linear debugging)
- Built-in reasoning suffices
- Task is primarily execution rather than analysis
- Overhead not justified by complexity
- Approach is clear, just needs implementation

## Usage

Silently assess problem complexity. Only invoke sequential-thinking MCP if explicit step tracking adds material value. Default to built-in reasoning for most tasks.

Do not announce use of the tool unless relevant to user.
