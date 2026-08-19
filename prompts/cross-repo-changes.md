# Cross-repo / cross-service changes

Use this prompt when a change requires coordinated edits across more than one
repository or service — e.g. an API contract change, a shared DB schema, a
DTO/type shared between a backend and a frontend repo, or a breaking change
to a shared package/library consumed elsewhere in the workspace.

## When this applies

- The request changes a contract, schema, or data shape that another repo
  depends on (REST/GraphQL response shape, DB schema consumed by a client in
  another repo, shared package, shared type/proto definitions).
- A correct fix requires touching both the producer and the consumer of the
  same contract.
- Does **not** apply to a change fully internal to one repo, even if that
  repo is deployed as a separate service.

## Risk

Classify a cross-repo contract change as **High**, even if the diff in any
single repo looks small. The risk is coordination failure, not diff size.

## Workflow

1. **Identify the source of truth repo.** Usually the producer/owner of the
   contract — the backend for an API shape, the schema owner for a DB
   migration, the publishing repo for a shared package. State which repo is
   authoritative for this change.
2. **Identify all consumers in scope**, based on what is actually available
   to read in this session. Do not assume the existence or behavior of a
   repo you cannot read.
3. **Prefer backward compatibility.** Choose an additive, non-breaking
   change (new optional field, new endpoint, deprecate-then-remove) over a
   breaking one when the request allows it. State explicitly when the
   request requires a breaking change.
4. **Plan per repo.** The before-implementation plan MUST list, per affected
   repo: what changes, and which repo must ship first if there is a
   sequencing dependency (e.g. migration before the consumer reads the new
   field).
5. **Session boundary.**
   - If only one repo is editable in this session and the change is
     backward-compatible: implement the source-of-truth side and state the
     required follow-up in the other repo(s) under Remaining risk / Impact.
   - If the change is **not** backward-compatible (removing/renaming a
     field, changing a type, tightening validation) and the consumer repo
     cannot be updated in the same session: **stop and ask** before
     proceeding. Shipping one side of a breaking contract change
     uncoordinated is a stop condition, not a residual risk to report after
     the fact.
6. **Verify compatibility, not just correctness.** For the repo(s) actually
   edited, verify the change compiles/type-checks/passes tests in isolation,
   AND state — from reading the consumer's actual usage, not assumption —
   whether the consumer will break, degrade, or continue to work unchanged.

## Output

Extend the standard before/after implementation format with:

```text
### Cross-repo impact
- Source of truth: <repo>
- Consumers affected: <repo> — <what breaks/changes>; <repo> — <unaffected>
- Sequencing: <what must ship first, if anything>
- Follow-up required outside this session: <none | explicit list>
```

## Stop conditions specific to this prompt

- A breaking contract change is requested but the consumer repo is not
  accessible in this session.
- Two repos disagree on the current contract (e.g. the frontend expects a
  field the backend no longer sends) and the source of truth cannot be
  determined from the code — ask which side is correct rather than guessing.
