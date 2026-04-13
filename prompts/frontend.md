# FRONTEND PROMPT

Chỉ đọc file này khi task liên quan Frontend.

Áp dụng cho:

- Next.js
- React
- TypeScript
- component, hook, page, client logic, UI flow

Nếu task là refactor Frontend, phải đọc thêm `@.cursor/prompts/refactor-safe.md`.
Nếu task là viết hoặc sửa test Frontend, phải đọc thêm `@.cursor/prompts/testing.md`.

---

# CONTEXT DISCOVERY

Tuân theo `mode` đã xác định ở `@.cursor/README.md`.

## strict

Tối thiểu phải đọc:

1. Toàn bộ file sẽ sửa
2. Ít nhất 1-2 file tương tự hoặc cùng vai trò
3. Flow gọi chính trước và sau điểm sửa
4. `.cursor/rules/rules.mdc` nếu có và phù hợp
5. `.cursor/skills/**/SKILL.md` nếu có và phù hợp

## quick

Tối thiểu phải đọc:

1. Toàn bộ file sẽ sửa
2. Ít nhất 1 file tương tự nếu thay đổi có ảnh hưởng đến convention hoặc shared pattern

Với thay đổi cực nhỏ và phạm vi thật sự rõ ràng:

- Có thể chỉ đọc phần code liên quan trực tiếp thay vì toàn bộ file
- Chỉ áp dụng khi có thể xác nhận thay đổi không ảnh hưởng ra ngoài block đó

## debug

Đọc theo chuỗi gây lỗi:

1. Điểm phát sinh lỗi
2. Component, hook, util, hoặc action bị gọi trước đó
3. Props, state, data flow, và side effect liên quan
4. Log, test, hoặc đường chạy có thể xác nhận root cause

Không sửa code ngay khi chưa xác định được root cause đủ chắc chắn.

## explore

Đọc flow, component tree, hook usage, và các file liên quan để đề xuất hướng làm. Không tự chuyển sang implement nếu user chưa yêu cầu.

---

# FRONTEND RULES

1. Ưu tiên convention của module hiện tại trước mọi best practice chung
2. Không đổi component API nếu không được yêu cầu
3. Không thêm state, effect, memo, hook, hoặc abstraction mới nếu chưa cần
4. Giữ đúng format, naming, import order, và pattern đang dùng trong khu vực code đó
5. Không dùng `any`
6. Không tự ý thêm validation, guard, null check, hoặc defensive code nếu style hiện tại của repo không dùng theo cách đó
7. Trước khi tạo hook, helper, utils, hoặc shared abstraction mới, phải kiểm tra utility global hoặc shared hiện có để tái sử dụng trước
8. Không tự ý đổi cấu trúc component, tách file, hoặc đổi render flow nếu task không yêu cầu
9. Nếu task chạm shared UI pattern, phải đọc thêm ít nhất 1-2 file tương tự để giữ consistency
10. Nếu có viết test thì bám `@.cursor/prompts/testing.md`
11. Nếu thay đổi có thể ảnh hưởng module khác, phải nêu rõ phạm vi ảnh hưởng trước khi thực hiện

---

# FRONTEND CHECK

Trước khi kết thúc, tự xác nhận:

1. Đã đọc đủ context Frontend theo `mode`
2. Đã giữ đúng component API và shared pattern hiện có
3. Không thêm abstraction, hook, hoặc utils mới khi project đã có sẵn thứ phù hợp
4. Không tạo side effect vượt ngoài phạm vi task
