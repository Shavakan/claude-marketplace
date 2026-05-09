# Prompt Anti-Patterns

Reference loaded when reviewing or debugging an existing prompt. Each entry pairs the smell with what to do about it.

## Conflicting instructions without priority
**Smell:** Two rules that can both fire on the same input, with no rule for which wins.
**Example:** "Be concise" + "Always show your reasoning step-by-step."
**Fix:** Add a tiebreaker (`When these conflict, prefer X`) or scope each rule to disjoint conditions.

## Assumed unstated context
**Smell:** Prompt references "the schema" / "our standards" / "the usual format" that the model hasn't seen.
**Fix:** Inline the schema/standard, or move it to a referenced file the model can Read.

## Vague success criteria
**Smell:** "High-quality output", "production-ready", "appropriate detail".
**Fix:** Replace with checkable rules — line count, required sections, format validation, examples of pass/fail.

## Overloading with unrelated tasks
**Smell:** One prompt asks the model to summarize, classify, translate, and rewrite.
**Fix:** Decompose into chained calls or distinct skills. One prompt = one job.

## Repetitive phrasing wasting tokens
**Smell:** Same constraint reiterated 3+ times with synonyms ("be concise. don't ramble. keep it short. avoid verbosity.").
**Fix:** State once, then enforce via output-format rules (line cap, bullet count).

## Implicit format expectations
**Smell:** "Give me a summary" without saying: bulleted? prose? markdown? word count?
**Fix:** Specify shape explicitly. Provide a 1-shot example if the shape is non-trivial.

## Mixing persona and technical instructions
**Smell:** "You are a senior engineer who is helpful and friendly. Use the Anthropic SDK with prompt caching enabled."
**Fix:** Separate persona block from technical block. Persona is rarely load-bearing — drop it unless tone is genuinely a constraint.

## Negation-only constraints
**Smell:** "Don't use jargon. Don't be verbose. Don't add boilerplate."
**Fix:** Models follow positive instructions better. Convert at least one to a positive rule with a target.

## Missing failure mode
**Smell:** Prompt assumes input always matches the happy path.
**Fix:** Add explicit "If you can't X, say `<sentinel>`" branch. Test that branch before shipping.

## Hidden chain-of-thought leakage
**Smell:** Asking for reasoning + final answer in one block, then expecting downstream code to parse only the answer.
**Fix:** Structure with explicit delimiters (`<reasoning>...</reasoning><answer>...</answer>`) or use thinking blocks if the model supports them.

## Test-set memorization
**Smell:** Few-shot examples that are too similar to expected real inputs — model parrots structure but doesn't generalize.
**Fix:** Use deliberately diverse examples; vary surface form while keeping the underlying pattern.
