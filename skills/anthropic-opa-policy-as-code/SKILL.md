---
name: anthropic-opa-policy-as-code
description: >-
  Implements policy-as-code with Open Policy Agent and Gatekeeper for Kubernetes,
  infrastructure configuration, and CI/CD. Use when security policies must be
  version-controlled, tested, audited, and enforced consistently. Curated from
  Anthropic-Cybersecurity-Skills.
domain: cybersecurity
subdomain: devsecops
source: https://github.com/mukul975/Anthropic-Cybersecurity-Skills/tree/main/skills/implementing-policy-as-code-with-open-policy-agent
source-license: Apache-2.0
license: Apache-2.0
adaptation: Curated adaptation for this workspace; not an unmodified upstream copy.
---

# Policy as Code with OPA

Use this skill when security or operational policy must be expressed as executable, reviewable, version-controlled rules.

## When to Use

- Kubernetes admission controls.
- CI/CD policy gates.
- Terraform or structured configuration policy checks.
- Organization-wide rules that must be consistently enforced.

## When NOT to Use

- General vulnerability scanning.
- Runtime threat detection.
- Network-policy enforcement when a native network-policy mechanism is the correct boundary.

## Workflow

1. Identify the policy decision and its enforcement boundary.
2. Define the rule as code with explicit allow/deny semantics.
3. Add positive and negative tests.
4. Run policy checks locally before CI.
5. Integrate policy validation into CI/CD.
6. Use admission enforcement only after measuring existing violations and defining an exception process.

## Security principles

- Prefer deny-by-default for security-critical policies.
- Keep policy source version-controlled and reviewable.
- Do not silently exclude namespaces, repositories, or resources from security policy.
- Separate policy authoring from policy deployment where practical.
- Start with audit/warn mode when introducing a policy to an existing system, then move to deny after remediation when the platform permits it.
- Record policy exceptions with owner, reason, scope, and expiry.

## Verification

- [ ] Policy has explicit scope and enforcement boundary.
- [ ] Positive and negative cases are tested.
- [ ] CI validates policy changes.
- [ ] Admission enforcement does not silently bypass security-critical resources.
- [ ] Exceptions are explicit and reviewable.
- [ ] Policy failures are visible and actionable.
