# `.cursor` — Không gian làm việc cho AI Agent

> **Ngôn ngữ / Language:** [Tiếng Việt](README.vi.md) · [English](README.md)

Đây là một bộ hướng dẫn có thể tái sử dụng cho AI coding agent.

Ý tưởng rất đơn giản:

**chỉ đọc thứ cần thiết → hiểu điều gì phải luôn đúng → thay đổi nhỏ và an toàn nhất → kiểm tra kết quả → báo cáo rõ ràng.**

Repository này được thiết kế như một **thư viện dùng chung**, không gắn với riêng một ứng dụng hay một đội ngũ.

---

## 1. Đây là gì?

Khi AI thay đổi phần mềm, nó có thể tạo ra một thay đổi nhìn có vẻ đúng nhưng lại sai về logic.

Workspace này giúp agent quyết định:

- cần đọc gì
- không cần đọc gì
- task thuộc loại nào
- điều gì có thể xảy ra sai
- cần kiểm tra gì trước khi nói rằng đã hoàn thành

Bạn **không cần hiểu mọi file** trong repository này để sử dụng.

### Bắt đầu từ đây

| Mục đích | File |
|---|---|
| Quy tắc chung cho toàn workspace | [`AGENTS.md`](AGENTS.md) |
| Công việc Frontend | [`prompts/frontend.md`](prompts/frontend.md) |
| Backend Java / Spring / GraphQL | [`prompts/backend.md`](prompts/backend.md) |
| Backend Node / Express / Prisma | [`prompts/backend-node.md`](prompts/backend-node.md) |
| Dựng UI từ Figma / screenshot | [`prompts/ui-design-to-code.md`](prompts/ui-design-to-code.md) |
| Cách kiểm tra evidence và rủi ro trước khi code | [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md) |
| Cách đánh giá review | [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md) |
| Cách thiết kế test | [`prompts/testing.md`](prompts/testing.md) |
| Cách refactor | [`prompts/refactor.md`](prompts/refactor.md) |
| Cách khởi tạo project | [`prompts/project-init.md`](prompts/project-init.md) |
| Danh sách và trạng thái skill | [`docs/skill-inventory.md`](docs/skill-inventory.md) |
| Ví dụ validation UI | [`docs/ui-design-validation-examples.md`](docs/ui-design-validation-examples.md) |
| Tự kiểm tra workspace | [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1) |

---

## 2. Luồng hoạt động đơn giản

Mọi task nhìn chung đi theo luồng này:

```text
User request
   ↓
[AGENTS.md](AGENTS.md)
   ↓
Chọn workflow nhỏ nhất nhưng phù hợp
   ↓
Chỉ đọc skill và reference thực sự cần
   ↓
Kiểm tra rule / contract / rủi ro quan trọng
   ↓
Thực hiện thay đổi
   ↓
Chạy các kiểm tra phù hợp
   ↓
PASS / FAIL / UNKNOWN
```

Điểm quan trọng là **không đọc tất cả mọi thứ**.

Task nhỏ thì giữ nhỏ.
Task khó thì kiểm tra sâu hơn.

---

## 3. Các thư mục có ý nghĩa gì?

```text
.cursor/
├── README.md                 # Hướng dẫn tiếng Anh
├── README.vi.md              # Hướng dẫn tiếng Việt
├── AGENTS.md                 # Quy tắc chung cho agent
├── rules/                    # Quy tắc khởi động runtime
├── prompts/                  # Hướng dẫn theo loại công việc
├── skills/                   # Các khả năng có thể tái sử dụng
├── contracts/                # Điều kiện mong đợi dạng máy đọc được
├── scripts/                  # Chương trình kiểm tra tự động
├── docs/                     # Ví dụ và tài liệu bảo trì
└── mcp.json                  # Cấu hình MCP tùy chọn
```

### Ý nghĩa từng thư mục

**`AGENTS.md`**

Là bộ quy tắc chính. Nó quyết định risk, scope, routing, approval, verification và safety.

**`prompts/`**

Là các hướng dẫn ngắn cho từng loại công việc, ví dụ frontend, backend, testing hoặc khởi tạo project.

**`skills/`**

Là các khả năng có thể tái sử dụng. Nhiều skill được copy/sync từ các project công khai. Chỉ đọc khi task thực sự cần.

**`contracts/`**

Mô tả bằng máy những điều phải đúng. Điều này giúp biến yêu cầu mơ hồ thành thứ có thể kiểm tra.

**`scripts/`**

Các chương trình dùng để kiểm tra xem kết quả thực tế có đúng yêu cầu hay không.

**`docs/`**

Ví dụ, inventory và ghi chú. Đây là tài liệu tham khảo, không phải nơi chứa global rule.

---

## 4. Nguyên tắc quan trọng nhất: mỗi rule có một nơi sở hữu

Một rule nên có **một nơi chính**.

Ví dụ:

| Nội dung | Nơi chính |
|---|---|
| Risk / scope / safety toàn cục | [`AGENTS.md`](AGENTS.md) |
| Rule frontend | [`prompts/frontend.md`](prompts/frontend.md) |
| Rule Java / Spring | [`prompts/backend.md`](prompts/backend.md) |
| Rule Node / Prisma | [`prompts/backend-node.md`](prompts/backend-node.md) |
| Evidence và failure analysis trước code | [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md) |
| Rule review | [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md) |
| Thiết kế test | [`prompts/testing.md`](prompts/testing.md) |
| Refactor | [`prompts/refactor.md`](prompts/refactor.md) |
| Luồng dựng UI theo design | [`prompts/ui-design-to-code.md`](prompts/ui-design-to-code.md) |
| Kiểm tra cấu trúc UI | [`skills/ui-design-validator/SKILL.md`](skills/ui-design-validator/SKILL.md) |
| Kiểm tra interaction UI | [`skills/ui-interaction-contract/SKILL.md`](skills/ui-interaction-contract/SKILL.md) |
| Kiểm tra FE ↔ BE | [`skills/cross-layer-contract/SKILL.md`](skills/cross-layer-contract/SKILL.md) |
| Kiểm tra contract BE | [`skills/backend-contract-validation/SKILL.md`](skills/backend-contract-validation/SKILL.md) |
| Kiểm tra state BE | [`skills/backend-state-transition/SKILL.md`](skills/backend-state-transition/SKILL.md) |
| Format contract UI | [`contracts/ui-design-contract.schema.json`](contracts/ui-design-contract.schema.json) |
| Format contract FE ↔ BE | [`contracts/cross-layer-contract.schema.json`](contracts/cross-layer-contract.schema.json) |
| Validator UI | [`scripts/ui/validate-design-contract.ps1`](scripts/ui/validate-design-contract.ps1) |
| Validator FE ↔ BE | [`scripts/cross-layer/validate-contract.ps1`](scripts/cross-layer/validate-contract.ps1) |
| Validator state BE | [`scripts/backend/validate-state-contract.ps1`](scripts/backend/validate-state-contract.ps1) |
| Validator cho hệ thống prompt | [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1) |

Các file khác nên **trỏ tới owner**, không copy lại cùng một bộ rule chi tiết.

Cách này giúp hệ thống dễ hiểu hơn và tiết kiệm context hơn.

---

## 5. Frontend và backend

### Task frontend

Bắt đầu từ [`prompts/frontend.md`](prompts/frontend.md).

Chỉ load capability bổ sung khi cần. Router frontend là [`prompts/frontend-vercel-skills.md`](prompts/frontend-vercel-skills.md).

Ví dụ:

- React / Next.js → [`skills/vercel-react-best-practices/SKILL.md`](skills/vercel-react-best-practices/SKILL.md)
- Shared component → [`skills/vercel-composition-patterns/SKILL.md`](skills/vercel-composition-patterns/SKILL.md)
- UI interaction → [`skills/ui-interaction-contract/SKILL.md`](skills/ui-interaction-contract/SKILL.md)
- FE ↔ BE boundary → [`skills/cross-layer-contract/SKILL.md`](skills/cross-layer-contract/SKILL.md)
- Kiểm tra cấu trúc design → [`skills/ui-design-validator/SKILL.md`](skills/ui-design-validator/SKILL.md)

### Task Java / Spring / GraphQL

Bắt đầu từ [`prompts/backend.md`](prompts/backend.md).

Chỉ load capability cần thiết, ví dụ [`skills/backend-contract-validation/SKILL.md`](skills/backend-contract-validation/SKILL.md), [`skills/backend-state-transition/SKILL.md`](skills/backend-state-transition/SKILL.md), hoặc [`skills/cross-layer-contract/SKILL.md`](skills/cross-layer-contract/SKILL.md).

### Task Node / Express / Prisma

Bắt đầu từ [`prompts/backend-node.md`](prompts/backend-node.md).

Dùng các capability validation tương tự khi trigger của chúng phù hợp.

---

## 6. Dựng UI từ Figma hoặc screenshot

Luồng chính:

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
Kiểm tra interaction / API khi cần
   ↓
Kiểm tra runtime / hình ảnh thực tế
```

Không coi UI là đúng chỉ vì **nhìn gần giống**.

Ví dụ design yêu cầu:

```text
Expected: 1 1 2 1 1 2
Observed: 1 1 2 1 / 1 2
Result: FAIL
```

Nếu design yêu cầu sáu item cùng một hàng thì implementation trên là sai.

Các ví dụ khác có ở [`docs/ui-design-validation-examples.md`](docs/ui-design-validation-examples.md).

---

## 7. Ngăn lỗi trước khi code

Với task lớn hoặc có rủi ro cao, agent nên thử tìm cách làm thiết kế sai **trước khi viết code**:

```text
Requirement
   ↓
Điều gì phải luôn đúng?
   ↓
Điều gì có thể làm nó sai?
   ↓
Kiểm tra / test nhỏ nhất để chứng minh điều đó
   ↓
Implementation
   ↓
Verify
```

Ví dụ:

- bấm hai lần tạo hai request
- hai người cùng sửa một dữ liệu
- response cũ ghi đè response mới
- xóa dòng cuối khiến pagination hiển thị trang rỗng
- UI và API hiểu khác nhau về field hoặc enum
- retry khiến một external action chạy hai lần
- UI thiếu một field bắt buộc
- một item trong grid tự xuống sai hàng

Chỉ kiểm tra những rủi ro thực sự có thể xảy ra. Không tạo checklist khổng lồ cho mọi task nhỏ.

Chi tiết nằm ở [`prompts/reference-crosscheck.md`](prompts/reference-crosscheck.md).

---

## 8. Contract và kiểm tra tự động

Một contract trả lời:

> **Điều gì phải đúng?**

Một validator trả lời:

> **Kết quả thực tế có đúng như vậy không?**

### UI

- Contract: [`contracts/ui-design-contract.schema.json`](contracts/ui-design-contract.schema.json)
- Validator: [`scripts/ui/validate-design-contract.ps1`](scripts/ui/validate-design-contract.ps1)

### FE ↔ BE

- Contract: [`contracts/cross-layer-contract.schema.json`](contracts/cross-layer-contract.schema.json)
- Validator: [`scripts/cross-layer/validate-contract.ps1`](scripts/cross-layer/validate-contract.ps1)

### Backend state

- Validator: [`scripts/backend/validate-state-contract.ps1`](scripts/backend/validate-state-contract.ps1)

### Sức khỏe của hệ thống prompt

- Validator: [`scripts/prompt/validate-workspace.ps1`](scripts/prompt/validate-workspace.ps1)

Chạy self-check sau khi sửa prompt, routing, contract hoặc validator:

```powershell
powershell -ExecutionPolicy Bypass -File .cursor/scripts/prompt/validate-workspace.ps1
```

---

## 9. Khởi tạo project

Chọn hướng dẫn nhỏ nhất phù hợp:

| Công việc | Hướng dẫn |
|---|---|
| Khởi tạo chung | [`prompts/project-init.md`](prompts/project-init.md) |
| Chỉ frontend | [`prompts/project-init-fe.md`](prompts/project-init-fe.md) |
| Chỉ backend | [`prompts/project-init-be.md`](prompts/project-init-be.md) |
| Tách frontend + backend | [`prompts/project-init-split.md`](prompts/project-init-split.md) |
| Chỉ API contract | [`prompts/project-init-contract.md`](prompts/project-init-contract.md) |

---

## 10. Review và test

### Review

- Review staged thông thường → [`prompts/staged-review.md`](prompts/staged-review.md)
- Review specification FE → [`prompts/frontend-spec-review-workflow.md`](prompts/frontend-spec-review-workflow.md)
- Review cường độ cao → [`prompts/codex-connector-review.md`](prompts/codex-connector-review.md)
- Rule review chung → [`prompts/review-output-baseline.md`](prompts/review-output-baseline.md)

### Testing

Dùng [`prompts/testing.md`](prompts/testing.md).

Nếu task cần TDD / test-first, load [`skills/tdd/SKILL.md`](skills/tdd/SKILL.md) khi trigger phù hợp.

---

## 11. Skill inventory

Thư mục `skills/` cố ý lớn. Không phải skill nào cũng cần đọc trong mọi task.

Xem [`docs/skill-inventory.md`](docs/skill-inventory.md) để biết:

- skill `ROUTED`: được nối trực tiếp vào workflow bình thường
- skill `CONDITIONAL`: chỉ load khi đúng task
- skill `MANUAL`: chỉ gọi khi user hoặc tình huống yêu cầu
- skill `INDIRECT`: được gọi thông qua workflow khác
- skill `GUARDED`: hữu ích nhưng không được phép ghi đè safety rule của workspace
- skill `NON-CORE`: không thuộc nhóm phát triển phần mềm cốt lõi hằng ngày

Một skill không nằm trong workflow mặc định **không có nghĩa là nó vô dụng**.

---

## 12. Upstream skills

Nhiều skill trong [`skills/`](skills/) được đồng bộ từ các project công khai.

Nguyên tắc đơn giản:

**không sửa skill upstream chỉ để ép nó phù hợp với workspace này.**

Thay vào đó, đặt behavior riêng của workspace trong:

- [`AGENTS.md`](AGENTS.md)
- [`prompts/`](prompts/)
- skill local trong [`skills/`](skills/)
- [`contracts/`](contracts/)
- [`scripts/`](scripts/)

Nếu một upstream skill yêu cầu điều gì xung đột với rule workspace, rule workspace được ưu tiên.

Thông tin source hiện tại: [`docs/skill-inventory.md`](docs/skill-inventory.md).

---

## 13. Sau khi sync skill

Khi thư mục `skills/` được cập nhật từ upstream:

```text
1. Refresh [skill inventory](docs/skill-inventory.md)
2. Kiểm tra route trong [AGENTS.md](AGENTS.md)
3. Kiểm tra các link prompt → skill
4. Tìm skill mới liên quan software nhưng chưa được route
5. Xóa tên skill cũ / không còn tồn tại
6. Chạy [workspace self-check](scripts/prompt/validate-workspace.ps1)
```

Không thêm skill vào context mặc định chỉ vì skill đó tồn tại.

---

## 14. Phiên bản ngôn ngữ

- **Tiếng Việt:** file này, [`README.vi.md`](README.vi.md)
- **English:** [`README.md`](README.md)

Hai file phải mô tả cùng một hệ thống. Khi kiến trúc thay đổi, hãy cập nhật cả hai.
