# Prompting Patterns

Reference loaded when constructing a new prompt. Patterns are tools, not requirements — pick the smallest set that solves the task.

## Chain-of-Thought (CoT)
**Use when:** Multi-step reasoning, math, code analysis, decisions with tradeoffs.
**How:** "Think step-by-step before answering" or scaffold steps explicitly (`First, identify X. Then, classify each as Y. Finally, output Z.`).
**Anti-use:** Trivial extraction or classification — adds latency without quality gain.

## Few-shot
**Use when:** The pattern is hard to describe but easy to demonstrate; format compliance matters.
**How:** 2–3 examples covering the variation surface. Use diverse examples — too-similar examples cause memorization rather than generalization.
**Anti-use:** Format is trivial (1 line of plain text). Just ask.

## Persona
**Use when:** Tone is a real constraint (customer-facing, educational level, domain expertise needed).
**How:** "You are a [role] who [specific qualifier]. You [specific behavior]."
**Anti-use:** Internal tools, code generation, structured output. Persona adds tokens without changing capability.

## Template / scaffold
**Use when:** Output must conform to a strict structure (JSON, form, report).
**How:** Provide the structure with placeholders. Combine with one-shot for non-trivial fields.
**Anti-use:** Free-form creative output where structure would constrain quality.

## Constitutional / rule-stack
**Use when:** Multiple soft constraints (tone, safety, brand, factual accuracy) need to coexist.
**How:** Explicit numbered rules + tiebreaker for conflicts. Test conflicts deliberately.
**Anti-use:** Single hard constraint — just state it.

## Sentinel-output / fail-fast
**Use when:** Some inputs shouldn't be processed and you need a parseable signal.
**How:** "If <condition>, output exactly `<sentinel>` and stop." Test the sentinel path.
**Anti-use:** Conditions that are subtle judgment calls — the model will guess wrong.

## Self-critique loop
**Use when:** Quality matters more than latency; output benefits from a second pass.
**How:** "Draft an answer. Then critique it for [criteria]. Then revise."
**Anti-use:** Real-time interaction; stable simple tasks where v1 is reliably good.

## Tool use / structured calls
**Use when:** The model needs to query data, compute, or take actions outside its context.
**How:** Define tools with strict schemas; let the model choose when to call. Don't pre-prompt the tool — let the model decide.
**Anti-use:** Single-call extraction tasks where the answer is already in context.

## Combining patterns

Most production prompts use 2–3 of these. Common stacks:
- **Few-shot + template:** classification with strict output schema.
- **Persona + constitutional:** customer support, content moderation.
- **CoT + sentinel:** code review, where some inputs should escalate rather than auto-fix.

Avoid stacking 4+ patterns — diminishing returns and conflicts get hard to debug.
