# FRONTEND SKILL ROUTER

## Purpose

Select and load only the frontend skills required by the current task.

This prompt is a router. The selected `SKILL.md` is the canonical source of detailed rules; do not duplicate those rules here.

Global workflow is defined in `@.cursor/AGENTS.md`. Frontend implementation policy is defined in `frontend.md`.

## Upstream skill policy

Treat third-party/upstream skills as **immutable dependencies**.

- Do not modify upstream `SKILL.md` files to customize repository behavior.
- Put repository-specific routing, overrides, and verification in `.cursor/prompts/`, `.cursor/skills/` (local skills only), contracts, or scripts.
- Do not copy upstream skill bodies into prompts.
- Do not read an upstream skill merely because another skill mentions it; load it only when its trigger matches the current task.
- Once an upstream skill has been read in the current task, do not reread it unless its content changed.

## Fast path

Align with the Quick/Trivial gate in `AGENTS.md`.

The skill gate may be waived only when:

- The change passes the applicable Quick/Trivial gate in `AGENTS.md`.
- No new page or route is created.
- No shared component API, fetch architecture, bundle strategy, or accessibility behavior changes.

Record:

```text
Agent skills gate: waived (Quick/Trivial local change)
Residual risk: ...
```

Otherwise, select only the skills whose signals match the task.

Quick work may skip optional Vercel skills unless a specific skill trigger applies.

## Selection

| Task signal | Skill to read |
|-------------|---------------|
| New web page/route with no supplied design | `vercel-react-best-practices` + `web-design-guidelines` |
| New web page/route with screenshot/Figma/mockup | `vercel-react-best-practices` only; load `web-design-guidelines` only for explicit UX/a11y review |
| React/Next.js fetch, RSC, hooks, effects, rendering, bundle | `vercel-react-best-practices` |
| Shared component API, boolean modes, compound UI, provider | `vercel-composition-patterns` |
| UI, form, keyboard, focus, responsive, or a11y review | `web-design-guidelines` |
| Spec is silent on UX after peer comparison | `ui-ux-pro-max` |
| Route/page transition or shared-element animation | `vercel-react-view-transitions` |
| React Native or Expo | `vercel-react-native-skills` |

Deployment, Vercel operations, cost audits, and documentation review are routed directly through `AGENTS.md`, not through this frontend implementation router.

When a visual design reference (screenshot / Figma / mockup) is provided, the provided visual reference is authoritative for observable UI requirements, and `ui-design-to-code` is responsible for reproduction. Technical frontend skills may still be loaded for engineering concerns, but `web-design-guidelines` and `ui-ux-pro-max` MUST NOT override the provided design or trigger a redesign.

Do not load React Native guidance for web work. Do not use `ui-ux-pro-max` instead of repository peer screens.

## New page gate

Before creating or substantially editing a new page or route:

1. Complete `reference-crosscheck.md` when required by `AGENTS.md`.
2. Read `vercel-react-best-practices` when the page/route introduces React/Next.js architecture, data fetching, rendering, bundle, or performance decisions.
3. Read `web-design-guidelines` only when the task contains an explicit UX/a11y review requirement, no reliable existing design/peer exists, or its specific trigger applies.
4. For screenshot/Figma/mockup work, use `ui-design-to-code` + `ui-design-validator`; do not add generic design guidance merely because a new page is being created.
5. Read additional skills only when their selection signal applies.
6. Read only the detailed rule files explicitly required by those skills.
7. Output the reference map and skill gate.

Do not edit `page.tsx` until the applicable gate is complete.

Repository layout, styling, and component conventions override greenfield examples from a skill.

## Skill gate output

```text
### Agent skills gate

| Skill | SKILL.md read | Detailed rules read | Applied to this task |
|-------|---------------|----------------------|----------------------|
| skill-name | yes/no/N/A | rule IDs or N/A | concrete application |

Waivers: ...
```

Rules:

- Mark `yes` only when the file was opened in the current task.
- Do not claim a skill was read if it was not opened.
- Do not list a skill that has no task signal.
- State concrete application, not a generic summary.
- Do not reread a skill already read in the current task unless it changed.

## Done

- [ ] Fast-path eligibility verified or applicable skills selected.
- [ ] Each selected `SKILL.md` actually read.
- [ ] Only required detailed rules loaded.
- [ ] New-page architecture skill loaded only when its trigger applies.
- [ ] Design reference path uses design-specific skills instead of generic redesign guidance.
- [ ] Repository peers take precedence over generic examples.
- [ ] Skill gate or explicit waiver included in the plan.
