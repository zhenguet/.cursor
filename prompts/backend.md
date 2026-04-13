# BACKEND PROMPT

Chỉ đọc file này khi task liên quan Backend.

Áp dụng cho:

- Java Spring
- GraphQL/API backend
- service, repository, mapper, domain, adaptor

Nếu task là refactor Backend, phải đọc thêm `@.cursor/prompts/refactor-safe.md`.
Nếu task là viết hoặc sửa test Backend, phải đọc thêm `@.cursor/prompts/testing.md`.

---

# CONTEXT DISCOVERY

Tuân theo `mode` đã xác định ở `@.cursor/README.md`.

## strict

Tối thiểu phải đọc:

1. Toàn bộ file sẽ sửa
2. Ít nhất 1-2 file tương tự hoặc cùng vai trò
3. Flow gọi chính trước và sau điểm sửa
4. `tamada-coresystem-backend/README.md`
5. `.cursor/rules/rules.mdc` nếu có và phù hợp
6. `.cursor/skills/**/SKILL.md` nếu có và phù hợp

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
2. Controller, resolver, service, hoặc application bị gọi trước đó
3. DTO, mapper, repository, và data flow liên quan
4. Log, test, hoặc đường chạy có thể xác nhận root cause

Không sửa code ngay khi chưa xác định được root cause đủ chắc chắn.

## explore

Đọc flow, tài liệu, và các file liên quan để đề xuất hướng làm. Không tự chuyển sang implement nếu user chưa yêu cầu.

---

# BACKEND RULES

1. Bám structure hiện tại của dự án trước, không áp mô hình mới nếu repo chưa dùng
2. Ưu tiên flow thực tế của module hơn template lý tưởng
3. Controller/GraphQL resolver phải mỏng, chủ yếu nhận request, chuyển DTO, gọi application, trả response
4. Business logic đặt ở application/domain theo flow hiện có, không nhồi vào controller
5. Repository/adaptor chỉ xử lý data access hoặc external integration
6. Tôn trọng mapper, predicate, repository, exception style đang có
7. Nếu module đang dùng `ObjectMapper.convertValue`, mapper class, hoặc repository abstraction, hãy theo pattern đó
8. Không tự ý thêm validation, null check, hoặc defensive code nếu spec không yêu cầu và repo không dùng theo cách đó
9. Trước khi tạo helper, service hỗ trợ, utility, hoặc shared abstraction mới, phải tìm thứ tương tự đã có trong module hoặc toàn project
10. Khi đụng tới API/GraphQL flow, đọc đủ request DTO, response DTO, application service, repository/adaptor, và test liên quan nếu có
11. Chỉ thêm test khi thật sự cần; nếu có viết test thì bám `@.cursor/prompts/testing.md`
12. Nếu thay đổi có thể ảnh hưởng module khác, phải nêu rõ phạm vi ảnh hưởng trước khi thực hiện

Ví dụ flow backend hiện tại thường là:

`presentation/graphql/*Controller -> application/*Application -> domain/* -> adaptor/db/*`

Không được tự ý áp architecture mới nếu module hiện tại đang theo flow khác.

---

# BACKEND CHECK

Trước khi kết thúc, tự xác nhận:

1. Đã đọc đủ context Backend theo `mode`
2. Đã tham chiếu `tamada-coresystem-backend/README.md` khi cần
3. Đã bám flow thực tế của module
4. Không nhồi business logic sai layer
5. Không tạo utility/helper/service trùng lặp khi project đã có sẵn
