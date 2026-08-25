# `.cursor` — Workspace cho AI Agent

> **Ngôn ngữ / Language:** [Tiếng Việt](README.vi.md) · [English](README.md)

Một bộ operating system có thể tái sử dụng cho AI coding agent.

Nguyên tắc thiết kế:

```text
Chỉ đọc thứ cần thiết
→ xác định điều gì phải luôn đúng
→ thực hiện thay đổi nhỏ và an toàn nhất
→ kiểm tra đúng độ sâu
→ báo cáo evidence và residual risk
```

Repository này được thiết kế như thư viện dùng chung. Rule riêng của từng ứng dụng nên nằm trong repository của ứng dụng đó.

## Bắt đầu từ đây

| Mục đích | Nơi sở hữu |
|---|---|
| Risk, scope, routing, approval, context, verification | [`AGENTS.md`](AGENTS.md) |
| Frontend | [`prompts/frontend.md`](prompts/frontend.md) |
| Backend Java / Spring / GraphQL | [`prompts/backend.md`](prompts/backend.md) |
| Backend Node / Express / Prisma | [`prompts/backend-node.md`](prompts/backend-node.md) |
| Security baseline dùng chung | [`prompts/security-baseline.md`](prompts/security-baseline.md) |
| Khởi tạo project | [`prompts/project-init.md`](prompts/project-init.md) |
| Khởi tạo FE | [`prompts/project-init-fe.md`](prompts/project-init-fe.md) |
| Khởi tạo BE | [`prompts/project-init-be.md`](prompts/project-init-be.md) |
| Khởi tạo FE/BE tách riêng | [`prompts/project-init-split.md`](prompts/project-init-split.md) |
| Contract FE↔BE | [`prompts/project-init-contract.md`](prompts/project-init-contract.md) |
| Evidence và failure analysis trước khi code | [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md) |
| Review baseline | [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md) |
| Testing | [`prompts/testing.md`](prompts/testing.md) |
| Refactor | [`prompts/refactor.md`](prompts/refactor.md) |
| Frontend skill router | [`prompts/frontend-vercel-skills.md`](prompts/frontend-vercel-skills.md) |
| Skill inventory | [`docs/skill-inventory.md`](docs/skill-inventory.md) |
| Security provenance | [`docs/security-skill-provenance.md`](docs/security-skill-provenance.md) |
| Workspace validator | [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1) |

## Kiến trúc

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

Mỗi rule có một nơi sở hữu. Các file khác chỉ reference owner thay vì copy lại policy.

### Ownership

- `AGENTS.md` — risk, scope, approval, routing, context, Git/data safety, verification toàn cục.
- `prompts/` — orchestration theo task và stack.
- `security-baseline.md` — security policy và security invariants dùng chung.
- `contracts/` — expected behavior dạng máy đọc được.
- `skills/` — capability chuyên biệt; nội dung upstream được coi là external dependency, còn curated security skills giữ provenance riêng.
- `scripts/` — validation có thể thực thi.
- `docs/` — inventory, provenance, examples và maintenance notes.

## Security workflow

Security dùng progressive disclosure, không phải một checklist khổng lồ luôn được load:

```text
Security-sensitive task
        ↓
security-baseline.md
        ↓
specialized skill khi đúng trigger
        ↓
security verification
```

Baseline bao phủ authentication, authorization, resource/tenant isolation, input/application security, browser security, secrets, service boundaries, observability và dependency risk.

Các curated specialized skills gồm:

- Trail of Bits sharp-edges
- Trail of Bits variant-analysis
- DevSecOps security scanning
- Malicious npm package triage
- OPA/Gatekeeper policy-as-code

Các skill này là conditional và không được load chỉ vì chúng tồn tại.

## FE / BE initialization

`project-init-fe.md` và `project-init-be.md` được giữ mỏng có chủ đích. Chúng chỉ xử lý setup riêng của stack và delegate security/contract policy cho canonical owner.

Với ứng dụng tách FE/BE:

```text
project-init-split
   ├── project-init-fe
   ├── project-init-be
   └── project-init-contract (chỉ khi đang định nghĩa API semantics cụ thể)
```

Split orchestrator là một workflow family nên không bị prompt-cap thông thường hiểu nhầm là các workflow độc lập.

## Contracts và validators

Repository có contract cho:

- UI design
- FE↔BE boundary
- backend state transitions

Schema dùng core fields rõ ràng và một `metadata` extension point có chủ đích, thay vì chấp nhận tùy ý mọi field lạ.

Chạy workspace validator:

```powershell
powershell -ExecutionPolicy Bypass -File .cursor/scripts/prompt/validate-workspace.ps1
```

CI cũng chạy validator này và parse toàn bộ JSON contract ở mỗi push và pull request.

## MCP configuration

Repository này **không chứa database credential hoặc MCP configuration riêng của workspace**.

Dùng [`mcp.example.json`](mcp.example.json) làm baseline portable và cấu hình MCP riêng trong Cursor environment của bạn.

Không commit production database URI, internal project path hoặc credential có quyền read/write vào repository general-purpose này.

## Skill inventory

Xem [`docs/skill-inventory.md`](docs/skill-inventory.md) để biết các skill `ROUTED`, `CONDITIONAL`, `MANUAL`, `INDIRECT`, `GUARDED` và `NON-CORE`.

Một skill không được route mặc định không có nghĩa nó bị lỗi hoặc vô dụng.

## Maintenance

Sau khi thay đổi prompt, rule, contract, routing hoặc skill provenance:

```text
1. Kiểm tra canonical ownership
2. Kiểm tra prompt/skill references
3. Kiểm tra contract schemas
4. Chạy validate-workspace.ps1
5. Để CI enforce cùng các kiểm tra đó
```

Khi một bug mới làm lộ ra failure pattern có thể tái sử dụng, cập nhật canonical rule owner hoặc verification method. Không biến general prompt thành catalog của từng bug cụ thể.

## Phiên bản ngôn ngữ

- Tiếng Việt: [`README.vi.md`](README.vi.md)
- English: [`README.md`](README.md)

Khi kiến trúc thay đổi, hai README phải được cập nhật đồng bộ về mặt ý nghĩa.
