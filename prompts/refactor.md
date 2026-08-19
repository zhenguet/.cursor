# REFACTOR

## Trigger

Read this prompt for internal structural changes intended to preserve observable behavior.

Examples include extracting logic, consolidating duplication, renaming internals, and moving responsibilities between existing modules.

Global risk, approval, scope, verification, and dependency routing are owned by `@.cursor/AGENTS.md`.

## Conditional design skills

Load only when the refactor actually needs them:

- `codebase-design` — module/interface/deep-module boundary or public surface redesign.
- `improve-codebase-architecture` — cross-cutting architecture or dependency-graph improvement.

Do not load architecture skills for a local mechanical refactor that can be verified without them.

## Structural objective

A refactor **SHOULD** state a concrete structural objective before starting.

State what becomes simpler, more cohesive, less coupled, or easier to verify.

If the proposed change cannot state that objective, do not start the refactor.

## Observable behavior

Unless explicitly included in the request, preserve:

- Return values and output shapes
- Exception type and externally observed message
- Writes, events, cache updates, and other side effects
- Public APIs, schemas, and query shapes
- Ordering, timing semantics, and async resolution behavior
- Logs used by operations or monitoring

If one of these must change, classify the work as a behavior change under `AGENTS.md`, state the impact, and obtain the required approval.

## Gate

Do not refactor until:

1. The structural objective is explicit and concrete.
2. Target callers, consumers, and tests are identified.
3. Existing behavior is understood well enough to state what remains unchanged.
4. Any bug involved has a confirmed root cause.

If impact remains unknown after graph and targeted file inspection, stop and ask according to `AGENTS.md` stop conditions.

## Impact tier

This is impact scope for the refactor — not the global risk label in `AGENTS.md`.

| Impact | Condition | Action |
|--------|-----------|--------|
| Local | Private/local change with no external callers | Localized implementation |
| Shared | Exported/shared code or multiple files | Include complete impact list in the approval plan |
| Boundary | Module boundary, public contract, or broad caller set | Break into independently verifiable steps |

If discovered impact exceeds the approved tier, stop, reclassify, and request approval.

## Required context

1. Use impact/caller/test graph queries when available.
2. For Standard/High, follow the reference workflow selected by `AGENTS.md`; do not load another copy unnecessarily.
3. Read the full target file.
4. Read direct callers and consumers.
5. Read existing tests that establish current behavior.
6. Read one structural peer only when it informs the intended module boundary.
7. Load the conditional architecture skill only when its signal applies.

Before editing, be able to state:

- What structure changes and what becomes simpler, more cohesive, less coupled, or easier to verify.
- What observable behavior remains unchanged.
- Which callers and tests are affected.

## Rules

1. Use the smallest diff that achieves the stated structural goal.
2. Keep the diff limited to the stated structural goal; leave unrelated cleanup, bug fixes, and formatting for separate work.
3. Reuse an existing abstraction when it already owns the responsibility.
4. Rename across module boundaries only when renaming is the request.
5. Preserve tests; update them only when structure, not behavior, requires it.
6. Surface missing coverage as risk. Add tests only when requested or required by the approved plan.
7. Report out-of-scope observations without changing them.

Use this format for an out-of-scope observation:

```text
### Out-of-scope observation
- Type: Bug | Tech debt | Improvement
- Location: file and symbol
- Evidence: ...
- Suggested action: separate fix | ticket | note only
```

## Output

Before implementation:

```text
### Structural objective
What becomes simpler / more cohesive / less coupled / easier to verify: ...

### Scope confirmation
...

### Risk
Trivial | Quick | Standard | High

### Impact tier
Local | Shared | Boundary

### Impact
- Files:
- Callers:
- Tests:

### Plan
...
```

For review-only work, use the review workflow selected by `AGENTS.md`.

For final reports, use the verification format in `AGENTS.md`.

## Done

- [ ] Structural objective and preserved behavior stated.
- [ ] Global risk and impact tier established.
- [ ] Callers, consumers, peers, and tests inspected.
- [ ] No unapproved behavior or contract change.
- [ ] Diff contains no unrelated cleanup.
- [ ] Mid-refactor scope growth handled through re-approval.
