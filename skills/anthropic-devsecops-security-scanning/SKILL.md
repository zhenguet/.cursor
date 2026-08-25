---
name: anthropic-devsecops-security-scanning
description: >-
  Integrates secrets detection, SAST, SCA, container/IaC scanning, and DAST into
  CI/CD using Gitleaks, Semgrep, Trivy, and OWASP ZAP. Use when establishing
  automated security gates, shift-left security, or CI/CD security verification.
  Curated from Anthropic-Cybersecurity-Skills.
domain: cybersecurity
subdomain: application-security
source: https://github.com/mukul975/Anthropic-Cybersecurity-Skills/tree/main/skills/implementing-devsecops-security-scanning
license: Apache-2.0
---

# DevSecOps Security Scanning

Use this skill to design or verify automated security checks in CI/CD. It complements manual security review; it does not replace it.

## When to Use

- New project CI/CD setup.
- Security gates before merge/deployment.
- Shift-left security requirements.
- SAST/SCA/secrets/container/IaC/DAST coverage.
- Security verification required by project policy or compliance.

## Security pipeline

Prefer layered checks:

```text
Secrets → SAST → SCA/IaC → Container → DAST → Security Gate
```

Use only the layers applicable to the project. Do not add heavyweight scanners without a concrete deployment or risk requirement.

## Recommended tools

| Layer | Typical tool | Purpose |
|---|---|---|
| Secrets | Gitleaks | Detect credentials and tokens in source/history |
| SAST | Semgrep | Detect code-level security patterns |
| SCA | Trivy / ecosystem audit | Detect vulnerable dependencies |
| Container | Trivy | Scan images and generate SBOM |
| IaC | Trivy / policy tools | Detect insecure infrastructure configuration |
| DAST | OWASP ZAP | Test deployed application behavior |

## Security gate design

- Define severity thresholds before enabling a blocking gate.
- Fail closed for confirmed critical/high findings when project policy requires it.
- Keep scan artifacts available for investigation.
- Distinguish scanner failure from a clean scan.
- Do not turn off a scanner merely to make CI green; record an explicit exception with scope and expiry.
- Keep branch protection/status checks aligned with the actual security gate.

## Secrets scanning

Scan full history when the threat model requires historical exposure detection. Never print real secrets in logs or reports. A revoked secret remains evidence of possible exposure and should be investigated.

## SAST

Start with maintained security rules. Add custom rules only for repository-specific invariants or recurring defects. Custom rules should have positive and negative tests.

## SCA and SBOM

- Prefer lockfile-resolved versions for vulnerability decisions.
- Generate an SBOM when deployment or supply-chain requirements justify it.
- Distinguish scanner coverage limits from a clean result.
- Do not claim that absence of findings proves dependency safety.

## DAST

DAST requires a running target. Use a controlled staging environment and ensure credentials, test data, and network boundaries are appropriate. Do not run intrusive scans against production unless explicitly authorized.

## Verification

- [ ] Secrets scanning is active at the appropriate scope.
- [ ] SAST runs on the relevant source changes.
- [ ] Dependency/security scanning uses resolved versions where possible.
- [ ] Container/IaC scanning is enabled when those artifacts exist.
- [ ] DAST is configured only when a deployed target exists and authorization permits it.
- [ ] Security gates have explicit thresholds and exception handling.
- [ ] Scanner failures are not silently treated as clean.
- [ ] Results are retained in a reviewable form.
