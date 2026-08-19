# REFERENCE CROSSCHECK

## Trigger

Read this prompt before Standard or High implementation, planning, refactoring, or spec-driven review.

Skip for Trivial and Quick work that passes the Quick gate in `AGENTS.md`; record the waiver.

The goal is to collect enough evidence to make implementation decisions confidently — not to hit a file count or reference quota.

Global risk, approval, graph, and scope policies are defined only in `@.cursor/AGENTS.md`.

---

## Evidence standard

Collect enough evidence to answer:

1. What should happen?
2. What currently happens?
3. What existing implementation establishes the convention?
4. What contract or test constrains the change?
5. What callers or consumers can be affected?

A reference is useful **only** if it validates or changes an implementation decision.

There is **no fixed reference-count requirement**. Prefer the smallest sufficient evidence set. Add another reference only when the current evidence leaves a material decision unresolved, reveals broader impact, or requires an independent confirmation.

Do not treat reference collection as completion. Do not implement Standard/High work until the reference map and defect-prevention gate are present in the approved plan, unless an explicit evidence-sufficient waiver is recorded.

---

## Discovery order

### 1. User-provided context

Read first:

- Tagged target files and folders
- Attached spec, ticket, plan, or `*.plan.md`
- Explicit legacy or peer references

Treat these as the starting set; do not replace them during discovery.

### 2. Repository context

Resolve the target git repository before searching. Do not assume every task belongs to one product.

Read when relevant:

- `CONTEXT-MAP.md` and the matching context `CONTEXT.md` when they exist (product paths, stack, and repo profile live there — not in this prompt)
- Repository or module README (architecture / setup)
- Relevant spec and shared conventions
- Target implementation and its public boundary

### 3. Structural discovery

When the repository is graph-indexed:

1. Use `semantic_search_nodes_tool` for feature, route, operation, class, or symbol names.
2. Use `query_graph_tool` for callers, callees, importers, and tests.
3. Use `get_impact_radius_tool` for shared or public changes.

Use targeted file search only for missing graph coverage, documentation, configuration, or non-code assets.

### 4. Peer selection

Choose a peer with the same structural role, not merely a similar name.

Examples:

- Backend: controller/resolver/router, application/service, repository/adaptor, mapper
- Frontend: page shape, query layer, persistence behavior, shared component
- Tests: same framework, test level, fixture style, and boundary
- Contracts: schema, DTO, validation, pagination, and error shape

Record what differs so the peer is not copied blindly.

### 5. Legacy parity

Read legacy code only when the request requires porting or parity.

Record:

- Behavior being preserved
- Legacy assumptions that should not be carried forward
- Missing or ambiguous parity evidence

If legacy is irrelevant, mark it `N/A`.

---

## Defect-prevention gate — BEFORE IMPLEMENTATION

Do not treat the implementation plan as complete until the task has a concise **Implementation Risk Contract**.

### 1. Must-hold invariants

State the 2–5 most important invariants that must remain true after the change.

Examples:

```text
I1: Only authorized users can perform the mutation.
I2: PENDING can transition to APPROVED only once.
I3: The response shape remains compatible with existing consumers.
I4: A successful mutation leaves the UI query state consistent with the new dataset.
```

### 2. Counterexamples

For every high-risk invariant, attempt at least one concrete counterexample **before coding**.

Use realistic failure modes:

- empty/null/boundary input
- duplicate submission/message
- concurrent actors
- stale state or stale response
- timeout / partial dependency failure
- permission mismatch
- pagination/filter result shrink
- malformed or unexpected payload

The plan must state the expected safe behavior for each counterexample.

### 3. State transitions

If the task changes status, lifecycle, approval, or other mutable state, define:

```text
Current state + action → next state
```

Also identify forbidden transitions and duplicate-execution behavior.

### 4. Boundary matrix

For API, DB, queue, external service, cache, or file boundaries, record:

```text
Boundary | Input | Output | Failure | Retry | Duplicate | Transaction timing
```

Do not implement an external side effect until its transaction timing and failure behavior are understood.

### 5. Data mutation impact

For write operations, explicitly identify:

- affected entities/rows
- expected row-count/cardinality changes
- ordering/pagination impact
- cache/state invalidation
- downstream events/notifications
- authorization/ownership checks

### 6. Verification mapping

Map each important invariant/counterexample to verification:

```text
Invariant/counterexample → test / runtime check / validator / evidence
```

A scenario with no verification path becomes an explicit residual risk, not an implied PASS.

### Complexity rule

Do not generate a giant analysis document. Use only the invariants and scenarios that can realistically fail in the touched flow.

---

## Output

Include this block before implementation:

```text
### Reference files crosscheck

| Role | File | Decision informed | Do not copy |
|------|------|-------------------|-------------|
| Spec | path | ... | ... |
| Target | path | ... | ... |
| Peer | path | ... | ... |
| Test/schema | path | ... | ... |
| Legacy | path or N/A | ... | ... |

Evidence answers:
1. Should happen: ...
2. Currently happens: ...
3. Convention source: ...
4. Contract/test constraint: ...
5. Callers/consumers: ...

### Implementation Risk Contract

Invariants:
- I1: ...
- I2: ...

Counterexamples:
- C1: scenario → expected safe behavior → verification
- C2: scenario → expected safe behavior → verification

State transitions: ... | N/A
Boundary matrix: ... | N/A
Data mutation impact: ... | N/A
Residual unknowns: ...

Gaps / unknowns: ...
Waiver (if evidence-sufficient): ...
```

Rules:

- Every path must have been read or inspected through graph evidence.
- Do not list search results that were not inspected.
- State blocked or missing evidence explicitly.
- If the required behavior or product intent remains materially unresolved, ask before implementation.
- Do not infer product intent from code, peers, or legacy behavior.
- Technical evidence gaps alone do not require asking when the required behavior is already clear from the request or spec.

For a new frontend page, continue with the new-page gate in `frontend-vercel-skills.md`.

---

## Done

- [ ] Target repository resolved; context `CONTEXT.md` read when it exists.
- [ ] User-provided context read first.
- [ ] Five evidence questions answered or gaps recorded.
- [ ] Each cited reference informs a decision.
- [ ] Implementation Risk Contract completed before coding.
- [ ] High-risk invariants challenged with concrete counterexamples.
- [ ] State transitions defined when applicable.
- [ ] Boundary and data-mutation impact checked when applicable.
- [ ] Every important invariant/counterexample has a verification path or explicit residual risk.
- [ ] Peer selected by structural role when a convention decision needed it.
- [ ] Caller, consumer, test, or schema evidence included where it changes risk.
- [ ] Legacy checked only for parity work.
- [ ] Differences and unknowns recorded.
