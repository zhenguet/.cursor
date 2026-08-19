# FRONTEND

## Trigger

Read this prompt for React, Next.js, TypeScript, component, hook, page, state, client-flow, and frontend behavior changes.

Use only when selected by `AGENTS.md` routing.

### Conditional skills

- `frontend-vercel-skills.md`: choose upstream frontend skills only when their signals match.
- `cross-layer-contract`: FE ↔ API/BE contract or server-backed mutation.
- `ui-interaction-contract`: user-visible action, form submission, navigation, loading/success/failure, or async interaction.
- `review-multi-source-state`: multiple sources represent the same logical field at the action boundary.
- `ui-design-to-code` + `ui-design-validator`: screenshot/Figma/mockup implementation.

Global risk, approval, evidence, context, and verification policy lives in `AGENTS.md`.

## Context gate

Before editing:

1. Resolve repository, target files, and public boundary.
2. Standard/High: complete the `Implementation Risk Contract` in `reference-crosscheck.md`.
3. Standard/High: inspect the full target, direct flow, relevant callers/consumers, and one structural peer when needed.
4. Trivial/Quick: use targeted reads; expand only when impact evidence requires it.
5. Trace the relevant component → state/hook → data/API/store flow.
6. Load only triggered skills.

For behavior-changing work, every important invariant/counterexample must have a verification path or explicit residual risk before implementation.

For a new page/route, complete the design/reference gate before editing the page entry file.

## Core implementation contract

### Components and state

- Preserve existing component APIs unless explicitly changed.
- Reuse existing components, hooks, utilities, and repository patterns.
- Prefer derived values and event-driven updates over unnecessary state/effects.
- Keep state ownership as narrow as practical.
- Preserve existing loading, empty, error, retry, and navigation semantics.

### TypeScript / API boundaries

- Do not use `any`.
- Use `unknown` with narrowing for genuinely unknown data.
- Prefer narrowing over casts; casts require a verified trust boundary.
- Match request/response schemas, nullability, and enums exactly.

### Data flow

- Do not introduce duplicate requests, fetch waterfalls, or render-loop fetching.
- Preserve cancellation and stale-response behavior.
- Preserve URL, persistence, cache, and back-navigation semantics unless explicitly changed.
- For multi-source action-time values, distinguish absent / present-empty / present-value.
- For mutations that can shrink a filtered/paginated result set, protect page/cursor, selection, and aggregate consistency.

## Defect prevention before coding

Challenge only the failure modes applicable to the task:

| Area | Challenge |
|---|---|
| Interaction | double action, stale response, cancellation, loading/disabled mismatch |
| State | impossible combinations, stale derived state, lost selection |
| Data flow | duplicate request, waterfall, stale cache, mutation/refetch inconsistency |
| Navigation | back-navigation loss, invalid redirect, unsaved-state loss |
| API boundary | request/response, nullability/enum, auth/permission mismatch |
| UI contract | missing/extra element, order, grid/span/wrapping mismatch when design exists |

Do not duplicate detailed validation rules here; consume the canonical validator/interaction/cross-layer capability.

## Runtime evidence

For a runtime/UI bug or visual regression, use browser/runtime evidence when available:

```text
reproduce → inspect relevant console/network/DOM evidence → fix → reproduce again
```

Skip runtime inspection for purely static/type-only changes.

## Performance / accessibility

Check only what the touched flow can affect:

- avoidable re-renders or unstable references
- redundant work in hot paths
- duplicate requests / waterfalls
- unnecessary server/client serialization
- shared component API complexity
- semantic controls, labels, keyboard/focus behavior

Use upstream frontend/design skills for deeper performance or UX/a11y guidance when their trigger applies; do not duplicate those rule sets here.

## Done

- [ ] Correct context depth for task risk.
- [ ] Only triggered skills loaded.
- [ ] Public/component/API contracts preserved or explicitly changed.
- [ ] Applicable failure modes challenged before coding.
- [ ] Important invariants/counterexamples mapped to verification or residual risk.
- [ ] Cross-layer contract checked when FE/API/BE boundary exists.
- [ ] Interaction contract checked for user-visible actions/async flows.
- [ ] Design validator checked when a design reference exists.
- [ ] Relevant runtime/performance/accessibility checks completed.
