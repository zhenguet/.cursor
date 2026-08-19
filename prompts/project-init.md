# PROJECT INIT — Router

## Trigger

Use when starting a new software project, creating a new repository/application, or when an existing project has no reliable architecture baseline.

## Routing

Choose the narrowest workflow:

| Situation | Workflow |
|---|---|
| General architecture-first | Use the General workflow below |
| Independent frontend | `project-init-fe.md` |
| Independent backend | `project-init-be.md` |
| Split FE + BE | `project-init-split.md` |
| FE/BE API contract | `project-init-contract.md` |

Load only the selected workflow and its explicitly required children. Do not bulk-load the project-init family.

## Global initialization rules

- Establish scope and boundaries before implementation.
- Mark missing information `UNKNOWN`; never invent product requirements.
- Prefer the simplest architecture that satisfies known requirements.
- Do not create speculative services, modules, infrastructure, or shared packages.
- Keep secrets out of source control; add `.env.example` when configuration is required.
- Define executable development and verification commands.
- Do not declare initialization complete until applicable checks pass.

## General workflow

```text
Scope
→ Architecture
→ Repository topology
→ Runtime/tooling
→ Boundaries
→ Configuration
→ Verification
→ Documentation
```

Produce only artifacts required by the selected architecture. Do not implement product features unless explicitly requested.

## Output

```text
## Project Initialization
Scope:
Architecture:
Repository topology:
Runtime/tooling:
Boundaries:
Configuration:
Verification:
Unknowns / assumptions:
```
