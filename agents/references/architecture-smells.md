# Architecture Smells — Reference

Loaded when reviewing changes that touch module boundaries, file structure, or coupling.

## God object / fat module
**Smell:** one class or file holds many unrelated responsibilities (auth + profile + notifications + billing).
**Signals:**
- File >300 lines
- Class with >15 public methods
- High fan-in from many unrelated callers
- Mixed import groups (network + persistence + UI in one file)

**Action:** propose split by domain boundary. Don't fragment for fragmentation's sake — the goal is one reason to change per module.

## Circular dependencies
**Smell:** module A imports B, B imports A (directly or transitively).
**Why it matters:** breaks build for some compilers; for others, causes initialization-order bugs and forces big-bang refactors later.
**Action:**
- Extract shared interface / type to a third module
- Use dependency inversion (B holds an abstraction A implements)
- Move the cross-cutting piece to a leaf module

## Mixed layers in one file
**Smell:** controller logic + service logic + persistence + validation in a single function.
**Signals:** raw SQL next to HTTP handling; framework decorators on functions that also touch DB.
**Action:** separate by layer (Controller → Service → Repository). Don't add layers prematurely — the smell only matters when the file gets edited often or causes test pain.

## Excessive parameters
**Smell:** function with 5+ positional parameters, especially of similar types.
**Risk:** call sites swap arguments silently (compiler can't help when types match).
**Action:** options object / dataclass with named fields. In statically-typed languages, declare the type explicitly.

## Implicit shared state
**Smell:** module-level mutable variables, singletons accessed via `getInstance()`, "context" objects passed everywhere.
**Risk:** untestable, order-dependent, surprising in concurrent code.
**Action:** explicit dependency injection; make state ownership obvious in the type signature.

## Reimplementing existing utilities
**Smell:** new helper function that duplicates `lodash.X` / `utils/X.ts` / a stdlib call.
**Detect:** before flagging, grep for the candidate utility; LSP `workspace_symbols` gives a more reliable signal.
**Action:** use the existing one if it fits. If the existing one is broken/incomplete, fix it rather than fork.

## Inappropriate intimacy / pattern violations
**Smell:** module A reaches into module B's internals (private fields, private functions, type-narrowing past a public abstraction).
**Risk:** changes to B's internals silently break A.
**Action:** widen B's public API deliberately, or move the logic to B if it really belongs there.

## Premature abstraction
**Smell:** a generic interface, base class, or factory introduced for a single concrete use.
**Risk:** the abstraction shape encodes guesses about a future that may not arrive; it makes the simple case complex.
**Action:** inline back to concrete code. Reintroduce the abstraction only when there are 2+ real implementations driving the shape.

## Large config / feature-flag debt
**Smell:** dozens of flags / env vars with no owner, no expiration, and unclear states.
**Risk:** combinatorial explosion of behaviors; flags become permanent forks.
**Action:** flags need an owner, a removal condition, and an expiration. Audit periodically; delete dead branches.

## Naming smells (load-bearing)
- `*Manager`, `*Handler`, `*Util`, `*Helper`, `*Service` — too vague to constrain scope. The name is fine as a starter; it's a smell when the file has grown without rename.
- `data`, `info`, `value`, `object` — names that describe nothing.
- Inconsistent casing within a single module — small but real signal of accreted authorship.

## When NOT to refactor
- Working code that's rarely touched. A smell in code you don't read again is not a problem worth fixing.
- Code at the edge of a deletion. Don't polish what's about to go.
- Anything where the refactor's blast radius exceeds the smell's cost.

The cost of architectural change is high; only refactor when the maintenance pain is real and recurring.
