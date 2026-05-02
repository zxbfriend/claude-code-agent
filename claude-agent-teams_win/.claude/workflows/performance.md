# Performance Workflow

Use this workflow for latency, throughput, memory, CPU, timeout, and scaling problems.

---

## Goal

Measure first, identify the real bottleneck, apply the smallest effective optimization, and verify impact with before/after metrics.

---

## Core Principle: Measure Before Optimizing

Never optimize based on intuition. Every change must have a measurable before/after comparison.

---

## Flow

### 1. Define the symptom and target metric
- Current P50/P99 latency? Current throughput (QPS)? Memory or CPU usage?
- Target: what does "fixed" look like? (e.g., P99 < 200ms, memory < 512MB)
- Affected endpoints or flows?

### 2. Gather evidence and narrow the bottleneck
The bottleneck is one of:
- **Database:** slow queries, missing indexes, N+1, full table scans (check with EXPLAIN)
- **Application logic:** inefficient algorithms, unnecessary computation, blocking I/O
- **External calls:** slow third-party APIs, no timeout configuration, no circuit breaker
- **Infrastructure:** undersized containers, no connection pooling, GC pressure

Evidence collection checklist:
- [ ] Slow query log or APM trace for the slow endpoint
- [ ] EXPLAIN output for suspect queries
- [ ] Thread dump if CPU is high or threads are blocked
- [ ] Memory heap dump or GC log if OOM or GC pauses are the issue
- [ ] Network latency to external services if external calls are suspect

### 3. Create diagnosis, optimization, validation, and review tasks
- Start execution immediately after creating tasks
- architect-agent is required if the optimization changes architecture (e.g., adding Redis, adding read replica)
- dba-agent is required if the optimization adds or changes indexes or schema

### 4. Optimization — smallest effective change
Apply changes in order of lowest risk first:
1. Add missing index → lowest risk, highest impact for DB bottlenecks
2. Optimize query (avoid N+1, remove unnecessary joins) → low risk
3. Add caching (in-memory or Redis) → medium risk (requires invalidation strategy)
4. Connection pool tuning → medium risk
5. Algorithm optimization → medium risk
6. Architectural change (async, sharding, read replica) → high risk, requires decision gate

### 5. Before/after validation (qa-agent)
- Required: benchmark both before and after the change under equivalent load
- Capture P50, P99, and max latency
- Capture throughput (req/s) under load
- Run functional regression to confirm no behavior change

### 6. Review
- reviewer-agent reviews the optimization code
- Pay special attention to cache invalidation correctness and index side-effects on write performance

### 7. Deliver
- pm-agent documents the bottleneck, change applied, and before/after metrics in `DELIVERY-REPORT.md`

---

## Decision Gate Scenarios

| Scenario | Gate Needed? |
|---|---|
| Add missing index | No |
| Add Redis caching (Redis not yet in stack) | Yes — new external dependency |
| Add read replica for DB | Yes — topology change |
| Switch from sync to async processing | Yes — behavioral change risk |
| Tune JVM heap or connection pool | No |
