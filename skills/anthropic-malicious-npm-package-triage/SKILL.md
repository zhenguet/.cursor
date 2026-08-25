---
name: anthropic-malicious-npm-package-triage
description: >-
  Defensively triages npm packages and lockfiles for malicious install scripts,
  credential exfiltration, obfuscation, and supply-chain compromise. Use when
  vetting a dependency, investigating a suspicious package, or responding to a
  known-malicious npm advisory. Requires an isolated disposable environment for
  any execution. Curated from Anthropic-Cybersecurity-Skills.
domain: cybersecurity
subdomain: supply-chain-security
source: https://github.com/mukul975/Anthropic-Cybersecurity-Skills/tree/main/skills/detecting-malicious-npm-packages
license: Apache-2.0
---

# Malicious npm Package Triage

Defensive analysis only. Never execute a suspect package on a developer workstation or any environment containing production credentials, SSH keys, cloud tokens, or privileged network access.

## When to Use

- Vetting a new npm dependency.
- Reviewing `package.json` / `package-lock.json` after a supply-chain advisory.
- Investigating a suspicious install or package.
- Designing a pre-install security gate.

## When NOT to Use

- Ordinary dependency vulnerability scanning without malware indicators.
- Offensive exploitation against third-party infrastructure.
- Running suspect packages in an environment with real credentials.

## Workflow

1. Acquire the package without executing lifecycle scripts.
2. Inspect `package.json` lifecycle hooks (`preinstall`, `install`, `postinstall`).
3. Run a static malware heuristic scanner such as GuardDog.
4. Review for credential/environment access, process execution, network exfiltration, obfuscation, and self-propagation.
5. Cross-check lockfile-pinned versions against OSV and known-malicious advisories.
6. If static evidence is inconclusive, use a disposable sandbox with egress and filesystem monitoring.
7. Record a defensible verdict: `benign`, `suspicious`, or `malicious`, with evidence.
8. Extract IOCs such as URLs, domains, IPs, hashes, and suspicious package versions when relevant.

## High-signal indicators

- Install lifecycle scripts that execute arbitrary commands.
- Reads of `process.env`, `.npmrc`, SSH keys, cloud credentials, or CI secrets.
- Outbound requests to unexpected domains.
- `eval`, base64/hex decoding, or heavily obfuscated payloads.
- Runtime process spawning unrelated to package purpose.
- Attempts to modify other packages, npm credentials, or publishing configuration.
- Unexpected persistence or self-propagation behavior.

## Safety boundary

Acquisition should use `npm pack` or equivalent with scripts disabled. Dynamic detonation is allowed only inside a disposable sandbox with no production credentials and controlled network egress.

## Verification

- [ ] Package was acquired without executing lifecycle scripts.
- [ ] Lifecycle scripts were reviewed.
- [ ] Static scan results were captured.
- [ ] Lockfile versions were checked against relevant advisories.
- [ ] Dynamic analysis, if needed, occurred only in an isolated sandbox.
- [ ] Verdict is evidence-backed.
- [ ] IOCs were recorded without exposing unrelated secrets.
