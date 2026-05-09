# Performance and Observability — Reference

Loaded when reviewing hot paths, data access, async work, or telemetry.

## Performance — hot signals

**N+1 queries**
- Smell: loop over rows, each iteration triggers a DB / RPC call.
- Detect: look for `for x in items: db.find(x.id)`, ORM relations accessed in a loop.
- Fix: batch fetch (`WHERE id IN (...)`), eager loading (`include`/`with`/`prefetch_related`), or denormalize if reads dominate.

**Quadratic where linear is possible**
- Smell: `O(n²)` over collections that could be set/map lookups; `array.includes` inside a loop.
- Fix: `Set` / `Map` for membership checks; sort then walk; sometimes a single SQL `JOIN` does it.

**Missing pagination / limit**
- Smell: endpoint returns all rows, full collection sent to client, unbounded `find().toArray()`.
- Fix: enforce `LIMIT` / cursor pagination at the data layer. Set an absolute max even when the caller doesn't pass one.

**Blocking ops on hot path**
- Smell: synchronous I/O in event-loop / async runtime, sync `fs.readFileSync` in a request handler, JSON.parse on huge payloads on the request thread.
- Fix: async equivalents; offload heavy CPU to a worker / queue.

**Unnecessary re-allocation**
- Smell: rebuilding the same regex / parser / config inside a loop; recompiling templates per request.
- Fix: hoist to module scope (once) or memoize.

**Large in-memory aggregations**
- Smell: `.map().filter().reduce()` chains over millions of rows in memory, then sent to a single consumer.
- Fix: stream / chunk; push aggregation to the DB; bound the working set.

## Memory

**Closures retaining large objects**
- Smell: callback / event handler closes over a request-scoped buffer; long-lived `Map<key, fnRef>` traps the original context.
- Fix: capture only what you need; explicitly nullify references after use; prefer weak references for caches keyed by short-lived objects.

**Unbounded buffers / queues**
- Smell: `[].push(x)` in a stream handler with no flush condition; in-memory queue with no max length.
- Fix: bounded buffer with backpressure; flush on size or time threshold.

## Observability gaps

**Money / auth / data ops without telemetry**
- Smell: charge / refund / login / signup / data-deletion paths with no log line, no metric, no trace.
- Fix: structured log with `userId`, `amount`, `correlationId`; counter / timer per outcome (`success`, `failure_<reason>`); error path is doubly important.

**External dependencies untimed**
- Smell: `await db.query(...)` / `await fetch(...)` with no latency metric.
- Fix: histogram per dependency + per method/endpoint. Names: `db.<op>.duration_ms`, `external.<service>.<op>.duration_ms`.

**Background jobs with no health signal**
- Smell: cron / queue worker with no "last successful run" metric, no error count.
- Fix: emit a heartbeat per cycle; emit an error counter; surface in dashboard with paging threshold.

**Logs without correlation**
- Smell: log lines from one request scattered across services with no shared ID.
- Fix: propagate `trace-id` / `request-id` through all hops; include in every log line.

**Cardinality explosion in metrics / logs**
- Smell: `logger.info("user signed in", { userId })` aggregated as a label / index, or per-user metrics labels.
- Fix: high-cardinality fields in *fields* (queryable), not *labels* (indexed). Dedicated tools (Honeycomb, Tempo, Loki) handle high cardinality; Prometheus labels do not.

**Sensitive data in logs**
- Smell: full request body, Authorization headers, password fields, PII, full stack traces with secrets.
- Fix: redact at the logger or middleware level; whitelist what gets logged on hot paths.

## Caching

**Stampede on cache miss**
- Smell: many concurrent requests trigger the same expensive recompute on TTL expiry.
- Fix: single-flight (one in-flight recompute, others wait), or stale-while-revalidate pattern.

**Cache key collision / unintended sharing**
- Smell: cache key omits a relevant axis (tenant, locale, user role).
- Fix: key includes every axis the value depends on; document the dependencies near the cache definition.

**Cache without invalidation strategy**
- Smell: TTL-only caches for data that changes via writes — stale window between write and TTL expiry.
- Fix: explicit invalidation on write; or accept staleness and document the SLA.
