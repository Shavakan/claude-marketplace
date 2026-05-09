# Correctness and Reliability — Reference

Loaded when reviewing logic, concurrency, error handling, or external-call resilience.

## Correctness

**Null / undefined dereference**
- Smell: chained `.x.y.z` without checks, optional fields treated as required, language-level "no NPE possible" assumptions.
- Fix: optional chaining + explicit defaults at the boundary; in TS, fix types instead of casting; in Go, check `err` even when "it can't fail".

**Off-by-one**
- Smell: `<=` where `<` belongs (or vice-versa), inclusive/exclusive range mismatch in pagination, `length-1` indexing.
- Fix: write both endpoints as concrete values for one example before generalizing. Add boundary tests (empty, single, length, length+1).

**TOCTOU (time-of-check / time-of-use)**
- Smell: `if exists(file) ... open(file)`, `if (!user.banned) ... allowAction()`, `if (count < limit) ... insert()`.
- Fix: atomic ops where possible (single SQL statement with constraint, `O_CREAT|O_EXCL` for files). Where not possible, document the race and bound the consequence.

**Integer overflow / precision**
- Smell: money in float, IDs as `int` for systems that scale past 2^31, `Math.floor(a / b)` that should round.
- Fix: integer cents (or arbitrary-precision) for money, `bigint` for IDs at scale, choose `floor` / `ceil` / `round` deliberately.

**Missing edge cases**
- Empty inputs (no items, empty string)
- Single-element inputs (often degenerate in algorithms)
- Boundaries (length, length+1, MAX_SAFE_INTEGER)
- Non-ASCII / multi-byte characters in string ops
- Negative numbers / zero where positives were assumed
- Time across DST boundary, leap seconds, year 2038 (32-bit time)

## Concurrency

**Race conditions**
- Smell: read-modify-write across requests without locking (`x = read(); x++; write(x)`).
- Fix: atomic op (`UPDATE ... SET x = x + 1`), CAS / optimistic locking with version column, or distributed lock if scope demands.

**Deadlock**
- Smell: nested locks acquired in inconsistent order across paths; lock held during external call.
- Fix: define a global lock-acquisition order; never hold a lock during I/O; prefer short critical sections + retry.

**Thread-unsafe shared state**
- Smell: module-level mutable state (caches, counters), global `Map`/`dict` written from multiple goroutines/threads/requests.
- Fix: language primitives (`sync.Map`, locks, atomics); for caches, use battle-tested libs (LRU with built-in locking).

**Async ordering assumptions**
- Smell: code that assumes promise resolution order, `Promise.all` results assumed to come in order they finished (they come in input order — but mutating shared state in `.then` is unsafe).
- Fix: don't mutate shared state from concurrent async work; collect results, then merge sequentially.

## Resource management

**Resource leaks**
- Smell: file handles / DB connections / sockets / timers opened but not always closed; `try` without `finally`/`defer`/`using`.
- Fix: language-idiomatic disposal (`with` in Python, `defer` in Go, `try-with-resources` in Java, `using`/`Symbol.dispose` in JS/TS, RAII in Rust/C++). Check error paths specifically.

**Unbounded growth**
- Smell: in-memory `Map`/`List` that only grows (caches without eviction, queues without backpressure, log buffers).
- Fix: bounded LRU, TTL eviction, backpressure signal, periodic cleanup job. Memory leaks usually look like bugs that "only happen in prod".

**Connection pool exhaustion**
- Smell: `connect()` without release on error, leaked transactions, recursion that re-acquires.
- Fix: release in `finally`; assert pool isn't held during external waits; configure pool size based on observed concurrency.

## Error handling

**Silent failure**
- Smell: `catch {}`, `except: pass`, `err != nil` ignored, unchecked promise (`fn()` without `await`/`then`).
- Fix: log, propagate, or recover deliberately. If swallowing is intentional, leave a comment naming the failure mode.

**Error type erased at boundary**
- Smell: `throw new Error("something failed")` where the cause was a typed error; `e.message` propagated without `cause`.
- Fix: wrap with `cause` (`new Error("...", { cause: e })`), preserve types, log the original at the catch site.

**Retry without limits**
- Smell: `while (true) { try retry } catch ...` without backoff or cap; auto-retry on errors that won't get better (4xx).
- Fix: bounded retries, exponential backoff with jitter, retry only on retriable errors (timeouts, 5xx, transient).

**No timeout on external calls**
- Smell: `fetch(url)` with no timeout, `db.query` with no statement timeout, `subprocess` with no kill-after.
- Fix: every external call has a timeout. The timeout budget is part of the contract — write it down.

**Unhandled promise rejection**
- Smell: `someAsyncOp()` not awaited, `.then()` without `.catch()`, async function called from sync context.
- Fix: await everything, or explicitly fire-and-forget with a logged catch handler.
