# Prompt skeleton

Copy and fill in. Order matters: front-loaded constraints, late instructions, examples last.

```
<role-and-task>
You are [role with specific qualifier]. Your job is to [verb + object + outcome].
</role-and-task>

<context>
[Background the model needs but doesn't already have. Schemas, domain rules, naming conventions. Prefer linked references over inline prose if the content is large and stable — they cache better.]
</context>

<rules>
1. [Hardest constraint first]
2. [Next hardest]
3. [Tiebreaker if rules conflict: "When 1 and 2 conflict, prefer 1."]
</rules>

<output-format>
[Exact structure. JSON schema, table columns, line cap, required sections.]
</output-format>

<failure-modes>
If [condition that should not be processed], output exactly `<sentinel>` and stop.
If you are uncertain about [specific axis], say so explicitly rather than guessing.
</failure-modes>

<examples>
Input: [diverse example 1]
Output: [matching the format above]

Input: [example 2 — different surface form, same pattern]
Output: [...]
</examples>

<task>
[The actual input goes here, or a placeholder.]
</task>
```

Trim sections that don't apply. A 4-line prompt for a trivial task is better than a 40-line prompt with 36 lines of unused scaffolding.
