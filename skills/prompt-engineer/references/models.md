# Model-Specific Prompting Guidance

Reference loaded when the request mentions a specific Claude model, asks about migration between model versions, or asks about token efficiency.

## Claude 4 family (current generation)

### Opus 4.x
- Handles deep reasoning, long contexts, subtle tradeoffs.
- Can follow elaborate constitutional / multi-rule prompts without drift.
- Use when correctness matters more than throughput. Spend budget on harder tasks; not on tasks Sonnet handles fine.

### Sonnet 4.x
- Balanced default. Most application code should target Sonnet.
- Strong tool use and structured output. Handles few-shot patterns well.
- Migrate Sonnet 4.5 → 4.6 → 4.7: review prompts that depended on old idiosyncrasies (over-explaining, refusing to take action). 4.7 is more decisive — strong "don't do X" guards may be needed where you previously relied on the model hesitating.

### Haiku 4.5
- Fast and cheap. Use for high-volume, narrow tasks: classification, extraction, lightweight rewrites.
- Prompts must be **shorter and more explicit** — Haiku doesn't infer as well as Sonnet/Opus.
- Provide concrete examples; avoid abstract instructions.
- Constrain output format aggressively — easier to validate than to interpret.

## Cross-model rules

- **Front-load the critical instruction.** Models attend more to the start and end of long prompts; the middle is where rules silently get lost.
- **System prompts persist; user prompts get cached differently.** Put stable, large content (style guides, schemas, reference docs) in the system prompt or in a cacheable prefix.
- **Thinking blocks are model-dependent.** Don't bake `<thinking>` syntax into prompts that may run on models without it.

## Migration checklist

When moving a prompt to a newer model:
1. Run the existing eval set unchanged. Note regressions.
2. Look for prompts that worked because of the old model's quirks (excessive caution, formatting guesses, refusal patterns) — the new model may behave differently.
3. Re-tune temperature and max_tokens; defaults that were right before may be wrong now.
4. If using prompt caching, verify the cache key is stable across the migration — small wording changes invalidate large prefixes.

## Token efficiency

Cheap wins, in order:
1. **Move large stable content to cached prefix.** Prompt caching gives ~10× cost reduction on hits.
2. **Replace prose enumerations with tables.** Tables compress better.
3. **Use delimiters instead of prose section headers** (`<schema>...</schema>` beats `Here is the schema:`).
4. **Cut "polite framing"** ("Could you please...", "I'd be grateful if..."). Direct imperative reads the same to the model.
5. **Short-circuit obvious failure paths** (early "If X, output `<sentinel>` and stop") — saves the model from generating unwanted long output.
