# SECURITY BASELINE

## Purpose

Provide the shared security baseline for new FE/BE projects and security-sensitive changes.

This is a reusable baseline, not a replacement for framework-specific security guidance, repository policy, or the application's explicit requirements.

## Core principles

- Deny by default.
- Authentication proves identity; authorization decides whether the actor may perform the requested operation on the requested resource.
- UI restrictions are not security controls. Authorization MUST be enforced at the backend/resource boundary.
- Do not invent an authentication or permission model when the product/security requirements are unknown. Record `UNKNOWN` and ask when the decision is material.
- Treat all client input, URL parameters, headers, uploaded files, webhook payloads, and external responses as untrusted.
- Never commit secrets, credentials, private keys, access tokens, or production data.
- Never log passwords, tokens, session identifiers, secrets, or unnecessary sensitive/PII data.

## Authentication

Define, when applicable:

- identity provider / authentication mechanism
- session or token model
- token/session lifetime and refresh behavior
- logout and revocation behavior
- password storage requirements if local credentials exist
- MFA/step-up authentication requirements when required
- authentication failure behavior
- service-to-service authentication and credential scope

Verify that protected resources cannot be reached through an unauthenticated path or alternate endpoint.

## Authorization and permissions

Define the authorization model before implementing protected business operations:

- roles and/or permissions
- resource ownership and tenant boundaries
- role hierarchy, if any
- action/resource mapping
- privileged operations
- deny-by-default behavior
- authorization enforcement location
- unauthorized (`401`) vs forbidden (`403`) semantics where applicable

For every sensitive operation, answer:

```text
Actor → Resource → Action → Authorization decision → Enforcement point
```

Check for:

- IDOR/BOLA
- privilege escalation
- horizontal access across users/tenants
- vertical access from lower to higher privilege
- authorization checks performed only in the frontend
- authorization based on client-controlled role/user/resource fields

## Input and application security

Validate and constrain untrusted input at the appropriate backend boundary.

Check, when applicable:

- injection (SQL/NoSQL/command/template)
- mass assignment / over-posting
- unsafe deserialization
- path traversal
- SSRF
- open redirects
- file upload type, size, storage, and execution controls
- webhook authenticity/signature verification
- replay protection for security-sensitive webhooks
- rate limiting / abuse controls
- pagination and resource limits

Use established framework/library mechanisms where available instead of custom security primitives.

## Browser / frontend security

For browser applications, define as applicable:

- token/session storage strategy
- cookie flags (`Secure`, `HttpOnly`, `SameSite`)
- CSRF protection for cookie-authenticated state changes
- XSS prevention and unsafe HTML boundaries
- route protection and session-expiry behavior
- safe handling of URL/query/hash input
- download/upload authorization
- Content Security Policy and relevant security headers
- frontend environment-variable boundaries

Never place a backend secret or private credential in browser-delivered code.

A frontend may hide or disable controls for UX, but this MUST NOT be treated as authorization.

## Data and secrets

Define:

- secret manager / credential source
- environment variable boundaries
- encryption requirements in transit and at rest when applicable
- sensitive-field handling
- retention/deletion requirements when known
- production-data access restrictions
- redaction rules for logs, traces, errors, and telemetry

`.env.example` may document variable names and non-secret placeholders; it MUST NOT contain real credentials.

## API / service security

For each public or internal service boundary, verify:

- authentication requirement
- authorization requirement
- input validation
- response/data exposure
- error information disclosure
- timeout and resource limits
- rate limiting where needed
- CORS policy where applicable
- replay/duplicate behavior for state-changing operations
- least-privilege credentials for external services

Health/readiness endpoints MUST expose only the information appropriate for their trust boundary.

## Observability and incident evidence

Security-relevant events should be auditable without recording secrets.

Consider:

- authentication failures
- authorization denials
- privileged actions
- security-sensitive configuration changes
- webhook/signature failures
- suspicious repeated requests

Do not leak stack traces, internal topology, credentials, SQL, or sensitive payloads through production errors or logs.

## Dependency and supply-chain security

For new projects:

- use lockfiles where supported
- prefer maintained, trusted dependencies
- run the repository's dependency/security audit when available
- avoid unnecessary dependencies
- do not copy third-party code without checking its license and provenance
- record security-relevant dependency limitations as `UNKNOWN` when they cannot be verified

## Security verification

Before initialization or a security-sensitive implementation is considered complete, verify the applicable items:

```text
Unauthenticated access        → blocked
Unauthorized resource access  → blocked
Cross-user/tenant access      → blocked
Privilege escalation          → blocked
Client-controlled privilege   → ignored/rejected
Sensitive input               → validated
Secrets in source/logs        → absent/redacted
Production errors             → no sensitive internals
Browser security              → applicable controls defined
External/webhook boundary     → authenticated/validated
Dependencies                  → audited when tooling exists
```

Every applicable item must be `PASS`, `FAIL`, or `UNKNOWN`. `UNKNOWN` is not PASS.

## Output

```text
### Security Baseline

Authentication: PASS/FAIL/UNKNOWN/N/A
Authorization model: PASS/FAIL/UNKNOWN/N/A
Resource/tenant isolation: PASS/FAIL/UNKNOWN/N/A
Input/application security: PASS/FAIL/UNKNOWN/N/A
Browser security: PASS/FAIL/UNKNOWN/N/A
Secrets/data security: PASS/FAIL/UNKNOWN/N/A
API/service boundaries: PASS/FAIL/UNKNOWN/N/A
Observability: PASS/FAIL/UNKNOWN/N/A
Dependencies/supply chain: PASS/FAIL/UNKNOWN/N/A
Residual risks / unknowns: ...
```
