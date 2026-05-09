# Few-shot skeleton

Use when the task is easier to demonstrate than describe (classification with edge cases, format conversion, tone transfer).

## Diversity rule

Pick 2–3 examples that span the **surface variation** the model will see in production. If all examples look similar, the model memorizes the surface form and fails on real inputs.

```
<examples>
<example>
<input>
[Realistic input. Show edge cases — long input, short input, ambiguous input. Don't curate to "easy" cases.]
</input>
<output>
[Output exactly matching the format you want in production. No extra commentary.]
</output>
</example>

<example>
<input>
[Different surface form — different length, different vocabulary, different structure. Same underlying pattern.]
</input>
<output>
[...]
</output>
</example>

<example>
<input>
[Edge case the model might mishandle — empty fields, ambiguous category, sentinel-trigger condition.]
</input>
<output>
[How you want that handled, including sentinel/refusal if applicable.]
</output>
</example>
</examples>

<task>
<input>
[Actual input here.]
</input>
<output>
```

## Common mistakes
- **Three examples that all match the same template** — model parrots, fails on novel inputs.
- **Examples that contradict the rules block** — model trusts examples over rules. Verify they agree.
- **Output examples with extra commentary** ("Here's the answer:") — model copies the commentary into production.
- **Forgetting an example for the failure path** — sentinel/refusal must appear in examples or the model won't emit it.
