# `.cursor` — AI Agent Workspace

> **Language / Ngôn ngữ:** [English](README.md) · [Tiếng Việt](README.vi.md)

A reusable operating system for AI coding agents.

The design principle is:

```text
Read only what is needed
→ identify what must stay true
→ make the smallest safe change
→ verify at the right depth
→ report evidence and residual risk
```

This repository is intentionally general-purpose. Application-specific rules belong in the target application's repository.

## Start here

| Purpose | Canonical owner |
|---|---|
| Global risk, routing, approval, context, verification | [`AGENTS.md`](AGENTS.md) |
| Frontend | [`prompts/frontend.md`](prompts/frontend.md) |
| Java / Spring / GraphQL backend | [`prompts/backend.md`](prompts/backend.md) |
| Node / Express / Prisma backend | [`prompts/backend-node.md`](prompts/backend-node.md) |
| Shared security baseline | [`prompts/security-baseline.md`](prompts/security-baseline.md) |
| Project initialization | [`prompts/project-init.md`](prompts/project-init.md) |
| FE initialization | [`prompts/project-init-fe.md`](prompts/project-init-fe.md) |
| BE initialization | [`prompts/project-init-be.md`](prompts/project-init-be.md) |
| Split FE/BE initialization | [`prompts/project-init-split.md`](prompts/project-init-split.md) |
| FE↔BE contract | [`prompts/project-init-contract.md`](prompts/project-init-contract.md) |
| Pre-coding evidence and failure analysis | [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md) |
| Review baseline | [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md) |
| Testing | [`prompts/testing.md`](prompts/testing.md) |
| Refactoring | [`prompts/refactor.md`](prompts/refactor.md) |
| Frontend skill router | [`prompts/frontend-vercel-skills.md`](prompts/frontend-vercel-skills.md) |
| Skill inventory | [`docs/skill-inventory.md`](docs/skill-inventory.md) |
| Security provenance | [`docs/security-skill-provenance.md`](docs/security-skill-provenance.md) |
| Workspace validator | [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1) |

## Architecture

```text
AGENTS.md
   ↓
primary domain prompt
   ↓
canonical policy / contract
   ↓
conditional specialized skill
   ↓
validator / tests / runtime evidence
```

One rule has one owner. Other files reference the owner instead of copying the policy.

### Ownership model

- `AGENTS.md` — global risk, scope, approval, routing, context, Git/data safety, verification.
- `prompts/` — task and stack orchestration.
- `security-baseline.md` — shared security policy and invariants.
- `contracts/` — machine-readable expected behavior.
- `skills/` — reusable specialized capabilities; upstream content is treated as external dependency, and curated security skills preserve provenance.
- `scripts/` — executable validation.
- `docs/` — inventory, provenance, examples, maintenance notes.

## Security workflow

Security is progressive-disclosure, not a giant default checklist:

```text
Security-sensitive task
        ↓
security-baseline.md
        ↓
specialized skill when triggered
        ↓
security verification
```

The baseline covers authentication, authorization, resource/tenant isolation, input/application security, browser security, secrets, service boundaries, observability, and dependency risk.

Curated specialized skills include:

- Trail of Bits sharp-edges
- Trail of Bits variant-analysis
- DevSecOps security scanning
- Malicious npm package triage
- OPA/Gatekeeper policy-as-code

They are conditional and must not be loaded merely because they exist.

## FE / BE initialization

`project-init-fe.md` and `project-init-be.md` are deliberately thin orchestration layers. They resolve only stack-specific setup and delegate shared security and contract policy to their canonical owners.

For split applications:

```text
project-init-split
   ├── project-init-fe
   ├── project-init-be
   └── project-init-contract (only when concrete API semantics are in scope)
```

The split orchestrator is one workflow family, so the normal prompt cap does not incorrectly reject its declared children.

## Contracts and validators

The repository includes contracts for:

- UI design
- FE↔BE boundaries
- backend state transitions

Schemas use explicit core fields and a deliberate `metadata` extension point rather than accepting arbitrary unknown properties everywhere.

Run the workspace validator locally:

```powershell
powershell -ExecutionPolicy Bypass -File .cursor/scripts/prompt/validate-workspace.ps1
```

CI runs the same workspace validator and parses every JSON contract on every push and pull request.

## MCP configuration

This repository does **not** contain workspace-specific database credentials or internal MCP configuration.

Use [`mcp.example.json`](mcp.example.json) as the portable baseline and provide local/private MCP configuration through the user's actual Cursor environment.

Never commit production database URIs, internal project paths, or read/write credentials into this general-purpose repository.

## Skill inventory

See [`docs/skill-inventory.md`](docs/skill-inventory.md) for `ROUTED`, `CONDITIONAL`, `MANUAL`, `INDIRECT`, `GUARDED`, and `NON-CORE` skills.

Do not treat an unreferenced skill as broken simply because it is not part of the default workflow.

## Maintenance

After changing prompts, rules, contracts, routing, or skill provenance:

```text
1. Check canonical ownership
2. Check prompt/skill references
3. Check contract schemas
4. Run validate-workspace.ps1
5. Let CI enforce the same checks
```

When a new bug exposes a reusable failure pattern, update the canonical rule owner or verification method. Do not build a permanent catalog of one-off bug examples into general prompts.

## Language versions

- English: [`README.md`](README.md)
- Vietnamese: [`README.vi.md`](README.vi.md)

Keep both descriptions semantically aligned when the architecture changes.
