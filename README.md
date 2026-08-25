# `.cursor` — AI Agent Workspace

> **Language / Ngôn ngữ:** [English](README.md) · [Tiếng Việt](README.vi.md)

A small, reusable instruction system for AI coding agents.

The main idea is simple:

**read only what is needed → understand what must stay true → make the smallest safe change → check the result → report clearly.**

This repository is designed to work as a **general-purpose library**, not as documentation for one specific application or team.

---

## 1. What is this?

When an AI agent changes software, it can make a change that looks correct but is logically wrong.

This workspace gives the agent a simple structure for deciding:

- what to read
- what not to read
- what kind of task it is
- what can go wrong
- what must be checked before calling the work complete

You do **not** need to understand every file here to use it.

### Start here

| Purpose | File |
|---|---|
| Rules for the whole workspace | [`AGENTS.md`](AGENTS.md) |
| Frontend work | [`prompts/frontend.md`](prompts/frontend.md) |
| Java / Spring / GraphQL backend work | [`prompts/backend.md`](prompts/backend.md) |
| Node / Express / Prisma backend work | [`prompts/backend-node.md`](prompts/backend-node.md) |
| UI from Figma / screenshot | [`prompts/ui-design-to-code.md`](prompts/ui-design-to-code.md) |
| Security baseline | [`prompts/security-baseline.md`](prompts/security-baseline.md) |
| How references and risks are checked before coding | [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md) |
| How reviews are judged | [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md) |
| How tests are planned | [`prompts/testing.md`](prompts/testing.md) |
| How refactoring is handled | [`prompts/refactor.md`](prompts/refactor.md) |
| How projects are initialized | [`prompts/project-init.md`](prompts/project-init.md) |
| Skill inventory | [`docs/skill-inventory.md`](docs/skill-inventory.md) |
| UI validation examples | [`docs/ui-design-validation-examples.md`](docs/ui-design-validation-examples.md) |
| Workspace self-check | [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1) |

---

## 2. The simple workflow

Every task follows roughly this path:

```text
User request
   ↓
[AGENTS.md](AGENTS.md)
   ↓
Choose the smallest suitable workflow
   ↓
Read only the skills and references that are actually needed
   ↓
Check important rules / contracts / risks
   ↓
Make the change
   ↓
Run the right checks
   ↓
PASS / FAIL / UNKNOWN
```

The important idea is **not to read everything**.

A small change should stay small.
A difficult change should get deeper checking.

---

## 3. How the folders are organized

```text
.cursor/
├── README.md                 # This guide, in English
├── README.vi.md              # Vietnamese version
├── AGENTS.md                 # Global agent rules
├── rules/                    # Runtime startup rules
├── prompts/                  # Task-specific instructions
├── skills/                   # Reusable capabilities
├── contracts/                # Machine-readable expectations
├── scripts/                  # Automatic checks / validators
├── docs/                     # Examples and maintenance notes
└── mcp.json                  # Optional MCP tool configuration
```

### What each folder means

**`AGENTS.md`**

The main rulebook. It decides risk, scope, routing, approval, verification, and safety.

**`prompts/`**

Short guides for a type of work, such as frontend, backend, testing, security, or project setup.

**`skills/`**

Reusable capabilities. Many are copied, adapted, or synced from public projects. They are normally loaded only when a task needs them.

**`contracts/`**

A machine-readable description of what must be true. This helps turn vague requirements into checks.

**`scripts/`**

Programs that check whether an expected rule is actually satisfied.

**`docs/`**

Examples, inventories, and explanations. These are reference material, not the source of global rules.

---

## 4. The most important rule: one owner for each rule

A rule should have **one main home**.

For example:

| Topic | Main owner |
|---|---|
| Global risk / scope / safety | [`AGENTS.md`](AGENTS.md) |
| Frontend rules | [`prompts/frontend.md`](prompts/frontend.md) |
| Java / Spring rules | [`prompts/backend.md`](prompts/backend.md) |
| Node / Prisma rules | [`prompts/backend-node.md`](prompts/backend-node.md) |
| Shared security baseline | [`prompts/security-baseline.md`](prompts/security-baseline.md) |
| Pre-coding evidence and failure analysis | [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md) |
| Review rules | [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md) |
| Test design | [`prompts/testing.md`](prompts/testing.md) |
| Refactoring | [`prompts/refactor.md`](prompts/refactor.md) |
| UI design implementation flow | [`prompts/ui-design-to-code.md`](prompts/ui-design-to-code.md) |
| UI structure checking | [`skills/ui-design-validator/SKILL.md`](skills/ui-design-validator/SKILL.md) |
| UI interaction checking | [`skills/ui-interaction-contract/SKILL.md`](skills/ui-interaction-contract/SKILL.md) |
| FE ↔ BE checking | [`skills/cross-layer-contract/SKILL.md`](skills/cross-layer-contract/SKILL.md) |
| Backend contract checking | [`skills/backend-contract-validation/SKILL.md`](skills/backend-contract-validation/SKILL.md) |
| Backend state checking | [`skills/backend-state-transition/SKILL.md`](skills/backend-state-transition/SKILL.md) |
| Security API/configuration design | [`skills/trailofbits-sharp-edges/SKILL.md`](skills/trailofbits-sharp-edges/SKILL.md) |
| Security variant hunting | [`skills/trailofbits-variant-analysis/SKILL.md`](skills/trailofbits-variant-analysis/SKILL.md) |
| CI/CD security scanning | [`skills/anthropic-devsecops-security-scanning/SKILL.md`](skills/anthropic-devsecops-security-scanning/SKILL.md) |
| Malicious npm triage | [`skills/anthropic-malicious-npm-package-triage/SKILL.md`](skills/anthropic-malicious-npm-package-triage/SKILL.md) |
| Policy as code | [`skills/anthropic-opa-policy-as-code/SKILL.md`](skills/anthropic-opa-policy-as-code/SKILL.md) |
| UI contract format | [`contracts/ui-design-contract.schema.json`](contracts/ui-design-contract.schema.json) |
| FE ↔ BE contract format | [`contracts/cross-layer-contract.schema.json`](contracts/cross-layer-contract.schema.json) |
| UI validator | [`scripts/ui/validate-design-contract.ps1`](scripts/ui/validate-design-contract.ps1) |
| FE ↔ BE validator | [`scripts/cross-layer/validate-contract.ps1`](scripts/cross-layer/validate-contract.ps1) |
| Backend state validator | [`scripts/backend/validate-state-contract.ps1`](scripts/backend/validate-state-contract.ps1) |
| Prompt workspace validator | [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1) |

Other files should **point to the owner**, not copy the same detailed rules again.

This keeps the system easier to understand and cheaper in context.

---

## 5. Frontend and backend

### Frontend task

Start with [`prompts/frontend.md`](prompts/frontend.md).

Load additional frontend capabilities only when needed. The frontend skill router is [`prompts/frontend-vercel-skills.md`](prompts/frontend-vercel-skills.md).

Common examples:

- React / Next.js implementation → [`skills/vercel-react-best-practices/SKILL.md`](skills/vercel-react-best-practices/SKILL.md)
- Shared component patterns → [`skills/vercel-composition-patterns/SKILL.md`](skills/vercel-composition-patterns/SKILL.md)
- UI interaction rules → [`skills/ui-interaction-contract/SKILL.md`](skills/ui-interaction-contract/SKILL.md)
- FE ↔ BE boundary → [`skills/cross-layer-contract/SKILL.md`](skills/cross-layer-contract/SKILL.md)
- Design structure validation → [`skills/ui-design-validator/SKILL.md`](skills/ui-design-validator/SKILL.md)
- Security-sensitive frontend design → [`skills/trailofbits-sharp-edges/SKILL.md`](skills/trailofbits-sharp-edges/SKILL.md)
- npm dependency security → [`skills/anthropic-malicious-npm-package-triage/SKILL.md`](skills/anthropic-malicious-npm-package-triage/SKILL.md)

### Java / Spring / GraphQL task

Start with [`prompts/backend.md`](prompts/backend.md).

Load only the needed capabilities, such as [`skills/backend-contract-validation/SKILL.md`](skills/backend-contract-validation/SKILL.md), [`skills/backend-state-transition/SKILL.md`](skills/backend-state-transition/SKILL.md), or [`skills/cross-layer-contract/SKILL.md`](skills/cross-layer-contract/SKILL.md).

Security-sensitive backend design can additionally route to [`skills/trailofbits-sharp-edges/SKILL.md`](skills/trailofbits-sharp-edges/SKILL.md), while CI/CD security work can route to [`skills/anthropic-devsecops-security-scanning/SKILL.md`](skills/anthropic-devsecops-security-scanning/SKILL.md).

### Node / Express / Prisma task

Start with [`prompts/backend-node.md`](prompts/backend-node.md).

Use the same conditional validation and security capabilities when their triggers apply. For npm supply-chain investigation, use [`skills/anthropic-malicious-npm-package-triage/SKILL.md`](skills/anthropic-malicious-npm-package-triage/SKILL.md).

---

## 6. Security workflow

Security is layered rather than copied into every project prompt:

```text
project-init-fe / project-init-be
          ↓
security-baseline.md
          ↓
specialized security skill when its trigger matches
          ↓
verification
```

The baseline covers authentication, authorization, resource isolation, input security, browser security, secrets, service boundaries, observability, and dependency risk.

Specialized skills add deeper procedures:

- **Trail of Bits sharp edges** — secure-by-default API/configuration design.
- **Trail of Bits variant analysis** — search for other instances after a known defect.
- **DevSecOps scanning** — CI/CD secrets, SAST, SCA, container/IaC, and DAST gates.
- **Malicious npm triage** — defensive investigation of suspicious npm packages.
- **OPA policy as code** — executable security policy for Kubernetes/IaC/CI/CD.

These skills are **conditional**. Do not load the entire security collection for an ordinary change.

---

## 7. UI from Figma or screenshot

For UI reproduction, the main path is:

```text
Design reference
   ↓
[prompts/ui-design-to-code.md](prompts/ui-design-to-code.md)
   ↓
[prompts/frontend.md](prompts/frontend.md)
   ↓
Design Contract
   ↓
Implementation
   ↓
[skills/ui-design-validator/SKILL.md](skills/ui-design-validator/SKILL.md)
   ↓
Interaction / API checks when needed
   ↓
Runtime / visual verification
```

A UI is not considered correct just because it **looks close**.

If the design says:

```text
Expected: 1 1 2 1 1 2
Observed: 1 1 2 1 / 1 2
Result: FAIL
```

the implementation is wrong when the intended row structure is one row.

More examples are kept in [`docs/ui-design-validation-examples.md`](docs/ui-design-validation-examples.md).

---

## 8. Prevent problems before coding

For larger or riskier work, the agent should challenge the design before writing code:

```text
Requirement
   ↓
What must always stay true?
   ↓
How could this fail?
   ↓
What is the smallest test or check that proves it?
   ↓
Implement
   ↓
Verify
```

Typical examples:

- two clicks create two requests
- two users change the same record at the same time
- an old API response overwrites a new one
- deleting the last row leaves an empty page
- the UI and API disagree about a field or enum
- a retry sends the same external action twice
- a required field disappears from the UI
- a grid item wraps to the wrong row

The agent should check only the risks that can actually happen in the task. It should not create a giant checklist for every small change.

The detailed pre-coding workflow is [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md).

---

## 9. Contracts and automatic checks

A contract answers:

> **What should be true?**

A validator answers:

> **Does the actual result match that expectation?**

### UI

- Contract: [`contracts/ui-design-contract.schema.json`](contracts/ui-design-contract.schema.json)
- Validator: [`scripts/ui/validate-design-contract.ps1`](scripts/ui/validate-design-contract.ps1)

### FE ↔ BE

- Contract: [`contracts/cross-layer-contract.schema.json`](contracts/cross-layer-contract.schema.json)
- Validator: [`scripts/cross-layer/validate-contract.ps1`](scripts/cross-layer/validate-contract.ps1)

### Backend state

- Validator: [`scripts/backend/validate-state-contract.ps1`](scripts/backend/validate-state-contract.ps1)

### Workspace health

- Validator: [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1)

Run the workspace check after changing prompts, routing, contracts, or validators:

```powershell
powershell -ExecutionPolicy Bypass -File .cursor/scripts/prompt/validate-workspace.ps1
```

---

## 10. Project setup

Use the smallest setup guide that matches the job:

| Job | Guide |
|---|---|
| General project setup | [`prompts/project-init.md`](prompts/project-init.md) |
| Frontend setup | [`prompts/project-init-fe.md`](prompts/project-init-fe.md) |
| Backend setup | [`prompts/project-init-be.md`](prompts/project-init-be.md) |
| Split frontend + backend | [`prompts/project-init-split.md`](prompts/project-init-split.md) |
| API contract only | [`prompts/project-init-contract.md`](prompts/project-init-contract.md) |

---

## 11. Reviews and tests

### Review

- Normal staged review → [`prompts/staged-review.md`](prompts/staged-review.md)
- Frontend specification review → [`prompts/frontend-spec-review-workflow.md`](prompts/frontend-spec-review-workflow.md)
- High-intensity review → [`prompts/codex-connector-review.md`](prompts/codex-connector-review.md)
- Common review rules → [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md)

For a confirmed security defect, `trailofbits-variant-analysis` can be loaded to search for the same root cause elsewhere instead of adding a one-off example to a global prompt.

### Testing

Use [`prompts/testing.md`](prompts/testing.md).

For TDD or test-first work, load [`skills/tdd/SKILL.md`](skills/tdd/SKILL.md) when its trigger applies.

---

## 12. Skill inventory

The `skills/` folder is intentionally large. Not every skill should be loaded for every task.

Use [`docs/skill-inventory.md`](docs/skill-inventory.md) to see:

- `ROUTED` skills: directly connected to normal workflows
- `CONDITIONAL` skills: loaded only for matching tasks
- `MANUAL` skills: user- or situation-driven
- `INDIRECT` skills: reached through another workflow
- `GUARDED` skills: useful but must not override workspace safety rules
- `NON-CORE` skills: not central to normal software development

A skill can be useful even when it is not part of the default workflow.

---

## 13. Upstream and curated skills

Many skills are synced or adapted from public projects.

The rule is simple:

**do not edit an upstream skill just to fit this workspace.**

For curated security skills, the local file is an explicit adaptation. It keeps source attribution and is intentionally routed only when the task signal matches.

Workspace-specific behavior belongs in:

- [`AGENTS.md`](AGENTS.md)
- [`prompts/`](prompts/)
- local skills in [`skills/`](skills/)
- [`contracts/`](contracts/)
- [`scripts/`](scripts/)

If an upstream skill asks for something that conflicts with the workspace rules, the workspace rules win.

For current source information and routing, see [`docs/skill-inventory.md`](docs/skill-inventory.md).

---

## 14. After syncing skills

When the `skills/` folder is updated from upstream or a curated security skill is added:

```text
1. Refresh [skill inventory](docs/skill-inventory.md)
2. Check [AGENTS.md](AGENTS.md) routes
3. Check prompt → skill links
4. Find new software-related skills that are not reachable
5. Remove old skill names
6. Verify imported/curated skill dependencies are complete
7. Run [workspace self-check](scripts/prompt/validate-workspace.ps1)
```

Do not add a skill to the normal context just because it exists.

---

## 15. Language versions

- **English:** this file, [`README.md`](README.md)
- **Vietnamese:** [`README.vi.md`](README.vi.md)

The two files should describe the same system. When the architecture changes, update both.
