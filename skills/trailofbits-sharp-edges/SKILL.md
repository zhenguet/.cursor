---
name: trailofbits-sharp-edges
description: >-
  Reviews security-sensitive APIs, configuration, authentication/authorization
  interfaces, and developer-facing choices for dangerous defaults, footguns,
  silent failures, type confusion, and insecure-by-default designs. Adapted from
  Trail of Bits sharp-edges for this workspace.
source: https://github.com/trailofbits/skills/tree/main/plugins/sharp-edges
source-license: CC-BY-SA-4.0
---

# Security Sharp Edges

Use this skill when a design exposes security-relevant choices to developers and
an insecure path could be easier than the secure path.

## When to Use

- Reviewing API or library design decisions.
- Reviewing authentication or authorization interfaces.
- Auditing configuration schemas and environment-controlled security settings.
- Evaluating cryptographic API ergonomics.
- Reviewing security-sensitive constructors, options, or defaults.
- Checking whether a feature is secure by default and difficult to misuse.

## When NOT to Use

- Ordinary implementation bugs with no security-design concern.
- Pure business-logic review.
- Performance-only optimization.
- Initial vulnerability discovery when no security-sensitive design decision is known.

## Core Principle

**The secure path should be the path of least resistance.** Documentation is not a substitute for safe defaults, constrained APIs, and explicit validation.

## Sharp-edge categories

### 1. Security-critical choice points

Look for developer-controlled parameters such as:

- algorithm, mode, cipher, hash, signature, or verification strategy
- authentication bypass flags
- permission/role selectors
- redirect or callback destinations
- TLS/certificate verification settings
- security feature enable/disable switches

Do not allow untrusted input to select a security-critical decision.

### 2. Dangerous defaults

Challenge:

- `false`, empty, `null`, `0`, or negative values that weaken security
- infinite or disabled timeouts
- optional authentication
- permissive CORS or origin handling
- disabled verification
- default credentials or fallback identities

Ask what happens for zero/empty/null/negative values and whether the default is the safest valid behavior.

### 3. Primitive vs semantic APIs

Prefer types and interfaces that distinguish security concepts. Avoid APIs where keys, nonces, signatures, tokens, identifiers, or permissions are interchangeable plain strings/byte arrays when the language permits stronger modeling.

### 4. Configuration cliffs

Configuration is part of the security boundary. Reject dangerous combinations rather than silently accepting them. Validate constructor parameters and runtime configuration instead of relying only on safe defaults.

### 5. Silent security failures

Look for:

- ignored verification return values
- empty exception handlers
- fallback behavior after failed validation
- malformed input treated as valid
- missing credentials treated as successful authentication

Security failure must fail closed and remain observable.

### 6. Stringly-typed security

Challenge permissions, roles, scopes, URLs, algorithms, and security modes represented as unconstrained strings when stronger types or allowlists are practical.

## Analysis workflow

1. Map authentication, authorization, cryptography, session, validation, and configuration boundaries.
2. Identify every developer-controlled security decision.
3. Probe zero/empty/null/negative and malformed values.
4. Check defaults and dangerous combinations.
5. Check whether security concepts can be confused or swapped.
6. Check failure paths for fail-open behavior.
7. Model a malicious developer, a rushed developer, and a confused developer.
8. Reproduce the misuse when feasible and verify whether it creates a real security consequence.

## Rationalizations to Reject

| Rationalization | Required response |
|---|---|
| "It is documented." | Prefer a safe default or constrained API. |
| "Advanced users need flexibility." | Keep unsafe primitives behind explicit, difficult-to-misuse boundaries. |
| "It is the developer's responsibility." | Treat the API/configuration design as part of the security boundary. |
| "Nobody would configure it that way." | Test the dangerous value and reject it when it is invalid. |
| "It is only configuration." | Validate configuration like code. |
| "Backwards compatibility requires the unsafe default." | Require an explicit migration or opt-in rather than preserving a dangerous default. |

## Verification

- [ ] Security-critical choices are constrained.
- [ ] Defaults fail closed and are safe.
- [ ] Zero/empty/null/negative values have explicit semantics.
- [ ] Security concepts cannot be accidentally interchanged where type safety is practical.
- [ ] Configuration combinations are validated.
- [ ] Security failures cannot silently become success.
- [ ] Authentication and authorization decisions are explicit.
- [ ] Findings are backed by a concrete misuse scenario and impact.
