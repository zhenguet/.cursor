# Skill Inventory

## Purpose

This file is the maintainability inventory for `.cursor/skills/` after upstream syncs and curated security-skill additions.

It answers three questions:

1. Is the skill reachable from the current `.cursor` workflows?
2. Is it relevant to software development?
3. Should it be auto-routed, conditionally routed, or kept manual-only?

This is **inventory/reference material**, not a second global policy source. `AGENTS.md` remains the canonical owner for routing policy.

## Status definitions

| Status | Meaning |
|---|---|
| `ROUTED` | Reachable from `AGENTS.md` or a primary prompt for normal software work. |
| `CONDITIONAL` | Software-relevant, but only load when the task signal matches. |
| `MANUAL` | Useful software workflow, but user-invoked or operational; do not load automatically. |
| `INDIRECT` | Normally reached through another skill/workflow rather than direct task routing. |
| `NON-CORE` | Not a core software-development capability; keep available only for its specialized purpose. |
| `GUARDED` | Software-relevant but contains behavior that conflicts with workspace kernel rules; do not auto-route until explicitly reconciled. |

`Unused` means **not auto-routed by the normal implementation/review prompts**. It does not mean the skill can never be invoked manually.

## Current routing / usage inventory

### Core engineering — routed or conditional

| Skill | Status | Software relevance | Current entry point / use |
|---|---|---|---|
| `backend-contract-validation` | ROUTED | High | `backend.md`, `backend-node.md` |
| `backend-state-transition` | ROUTED | High | `backend.md`, `backend-node.md` |
| `code-review` | ROUTED | High | `AGENTS.md` review routing |
| `codebase-design` | ROUTED | High | `AGENTS.md`, `refactor.md` when boundary design changes |
| `cross-layer-contract` | ROUTED | High | `frontend.md`, backend prompts, UI workflow |
| `diagnosing-bugs` | ROUTED | High | `AGENTS.md` hard bug/regression routing |
| `domain-modeling` | ROUTED/CONDITIONAL | High | `AGENTS.md` and advanced planning workflows |
| `improve-codebase-architecture` | ROUTED | High | `AGENTS.md`, `refactor.md` when cross-cutting |
| `tdd` | ROUTED | High | `AGENTS.md`, `testing.md` when test-first |
| `ui-design-to-code` | ROUTED | High | UI design workflow |
| `ui-design-validator` | ROUTED | High | UI design workflow |
| `ui-interaction-contract` | ROUTED | High | FE/UI interaction workflows |
| `ui-ux-pro-max` | CONDITIONAL | High | FE design/UX decision when its trigger matches |
| `vercel-composition-patterns` | CONDITIONAL | High for React | `frontend-vercel-skills.md` |
| `vercel-react-best-practices` | CONDITIONAL | High for React/Next | `frontend-vercel-skills.md` |
| `vercel-react-native-skills` | CONDITIONAL | High for React Native | `frontend-vercel-skills.md` |
| `vercel-react-view-transitions` | CONDITIONAL | High for React/Next motion | `frontend-vercel-skills.md`, `animation-checklist.md` |
| `web-design-guidelines` | CONDITIONAL | High for web UX/a11y | `frontend-vercel-skills.md` |
| `vercel-optimize` | MANUAL/CONDITIONAL | High for deployed Vercel audits | `vercel-optimize.md` |
| `deploy-to-vercel` | MANUAL | High for deployment | Explicit deployment request |
| `vercel-cli-with-tokens` | MANUAL | High for Vercel auth/setup | Explicit credential/CLI setup |
| `setup-ts-deep-modules` | MANUAL | High for TypeScript architecture | Explicit deep-module/package-boundary setup |
| `resolving-merge-conflicts` | MANUAL | High | Explicit merge/rebase conflict |
| `setup-pre-commit` | MANUAL | High | Explicit pre-commit/Husky setup |
| `migrate-to-shoehorn` | MANUAL | Medium/High | Explicit migration task |

### Security — curated upstream-derived skills

These skills were selected from high-signal public security skill repositories and adapted into local Cursor-compatible skills. They are **conditional**, not globally loaded.

| Skill | Status | Source | Trigger |
|---|---|---|---|
| `trailofbits-sharp-edges` | CONDITIONAL | Trail of Bits `sharp-edges` | Security-sensitive API/configuration design, dangerous defaults, fail-open behavior |
| `trailofbits-variant-analysis` | CONDITIONAL | Trail of Bits `variant-analysis` | Confirmed vulnerability/logic bug; search for equivalent root-cause variants |
| `anthropic-devsecops-security-scanning` | CONDITIONAL | Anthropic-Cybersecurity-Skills `implementing-devsecops-security-scanning` | CI/CD security gates, SAST/SCA/secrets/container/IaC/DAST |
| `anthropic-malicious-npm-package-triage` | CONDITIONAL | Anthropic-Cybersecurity-Skills `detecting-malicious-npm-packages` | npm dependency vetting or suspected malicious package |
| `anthropic-opa-policy-as-code` | CONDITIONAL | Anthropic-Cybersecurity-Skills `implementing-policy-as-code-with-open-policy-agent` | OPA/Gatekeeper policy enforcement for Kubernetes/IaC/CI/CD |

### Planning / product / repository operations — software-relevant but manual

| Skill | Status | Software relevance | Use |
|---|---|---|---|
| `prototype` | MANUAL | High | Prototype UI/state/logic to answer a design question |
| `research` | MANUAL | High | Technical/API/documentation research |
| `to-spec` | MANUAL | High | Turn discussion into an implementation spec |
| `to-tickets` | MANUAL | High | Break approved work into tracer-bullet tickets |
| `triage` | MANUAL | High | Issue/PR triage and agent-ready briefs |
| `wayfinder` | MANUAL | High | Very large multi-session engineering planning |
| `grill-me` | CONDITIONAL | Medium/High | Clarify and challenge plans/decisions |
| `grill-with-docs` | CONDITIONAL | Medium/High | Plan interrogation with documentation context |
| `grilling` | CONDITIONAL | Medium/High | Requirement/domain clarification |
| `handoff` | MANUAL | Medium | Agent/human handoff workflow |

### Runtime / toolchain / platform — software-relevant but specialized

| Skill | Status | Software relevance | Use |
|---|---|---|---|
| `setup-matt-pocock-skills` | MANUAL | Medium | Install/configure the upstream skill collection |
| `wizard` | MANUAL | High | Credentials, infrastructure, third-party setup, one-off cutover/migration |
| `git-guardrails-claude-code` | NON-CORE | Medium | Claude Code-specific Git guardrails; not a Cursor core workflow |
| `claude-handoff` | NON-CORE | Medium | Claude-specific handoff |

### Non-core / educational / writing / meta skills

| Skill | Status | Software relevance | Reason |
|---|---|---|---|
| `ask-matt` | NON-CORE | Low/Medium | External expert/persona consultation rather than engineering capability |
| `caveman` | NON-CORE | Low | Output/token compression, not software engineering |
| `claude-handoff` | NON-CORE | Medium | Claude-specific handoff |
| `loop-me` | NON-CORE | Low/Medium | Generic process loop rather than software-specific capability |
| `scaffold-exercises` | NON-CORE | Medium | Educational exercise/scaffolding rather than production engineering |
| `teach` | NON-CORE | Medium | Teaching/learning workflow |
| `to-questionnaire` | NON-CORE | Medium | Requirements/questionnaire workflow; useful in product discovery but not implementation core |
| `wait-what` | NON-CORE | Unknown until task signal | Meta/interaction utility; not part of normal software routing |
| `writing-beats` | NON-CORE | Low | Long-form writing workflow |
| `writing-for-agents` | NON-CORE | Medium | Documentation/agent-content authoring, not implementation |
| `writing-fragments` | NON-CORE | Low | Writing fragments |
| `writing-guidelines` | NON-CORE | Medium | Documentation/content quality; not core coding |
| `writing-shape` | NON-CORE | Low/Medium | Writing structure |
| `implement` | GUARDED | High | Software implementation skill, but its current SKILL.md instructs the agent to commit automatically; that conflicts with `.cursor/AGENTS.md` Git-write policy. Do not auto-route it. |

## Skills intentionally not used by normal FE/BE implementation

These are **not missing** from the workspace. They are intentionally outside normal auto-routing because they are specialized or user-invoked.

```text
ask-matt
caveman
claude-handoff
git-guardrails-claude-code
handoff
loop-me
migrate-to-shoehorn
prototype
research
resolving-merge-conflicts
scaffold-exercises
setup-matt-pocock-skills
setup-pre-commit
setup-ts-deep-modules
teach
to-questionnaire
to-spec
to-tickets
triage
wayfinder
wait-what
wizard
writing-beats
writing-for-agents
writing-fragments
writing-guidelines
writing-shape
```

Security skills are deliberately excluded from this manual-only list because they are now conditionally routed by `project-init-fe.md`, `project-init-be.md`, and `security-baseline.md`.

## Missing / stale routing discovered during sync review

The previous `AGENTS.md` referenced skill names that no longer exist in the synced `skills/` tree:

```text
design-an-interface
to-prd
to-issues
```

Those references have been removed from canonical routing. Use the currently installed equivalents such as `codebase-design`, `to-spec`, and `to-tickets` when their task signals apply.

## Upstream-derived skill policy

Security skills imported from public repositories are **curated, not blindly copied**.

- Preserve the upstream source URL and license information in the local skill frontmatter.
- Keep workspace-specific routing in `prompts/` and `security-baseline.md`.
- Do not make upstream-derived skills globally active merely because they exist.
- Prefer general security capabilities over one-off exploit catalogs.
- Review imported skills for unsafe commands, unsupported assumptions, and missing dependencies before routing them.
- If a future upstream skill requires supporting files/scripts, import the complete required dependency set or create a deliberate local adaptation; do not leave broken references.

## Maintenance rule

After every upstream skill sync or security-skill addition:

1. Refresh this inventory from the current `skills/` tree.
2. Check `AGENTS.md` and `prompts/` for broken skill references.
3. Distinguish `ROUTED`, `CONDITIONAL`, `MANUAL`, `INDIRECT`, `NON-CORE`, and `GUARDED` rather than calling every unreferenced skill “unused”.
4. Do not modify third-party skills merely to make routing pass.
5. Resolve routing drift in `AGENTS.md` / `prompts/`, not inside upstream-derived skills.
6. For local adaptations, preserve source attribution and document what was intentionally omitted or changed.

This inventory is documentation, not an execution contract.
