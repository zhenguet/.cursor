# REFACTOR SAFE PROMPT

Chỉ đọc file này khi task là refactor hoặc có thay đổi cấu trúc nội bộ vượt quá bugfix cục bộ.

Áp dụng cho:

- tách function
- gom logic
- đổi structure nội bộ
- giảm duplication
- cải thiện maintainability mà không đổi behavior mong muốn

Nếu refactor Backend, phải đọc thêm `@.cursor/prompts/backend.md`.
Nếu refactor Frontend, phải đọc thêm `@.cursor/prompts/frontend.md`.
Nếu refactor có kèm test, phải đọc thêm `@.cursor/prompts/testing.md`.

---

# REFACTOR GOAL

Refactor phải an toàn, nhỏ bước, và giữ nguyên behavior trừ khi user yêu cầu đổi behavior.

Không dùng refactor làm cớ để:

- đổi architecture lớn
- đổi API/contract
- đổi schema
- đổi naming rộng
- dọn dẹp lan man ngoài phạm vi

---

# CONTEXT DISCOVERY

Theo `mode`, tối thiểu phải đọc:

1. Toàn bộ file sẽ refactor
2. Ít nhất 1-2 file tương tự hoặc cùng vai trò
3. Call sites hoặc usages liên quan nếu refactor có thể ảnh hưởng ra ngoài file
4. Test hiện có quanh khu vực đó nếu có

Trong `debug mode`, phải xác định rõ đây là refactor để hỗ trợ fix hay chỉ là cleanup. Không refactor lớn khi root cause chưa chắc chắn.

---

# REFACTOR RULES

1. Phải giữ nguyên behavior, contract, và side effect hiện có nếu user không yêu cầu đổi
2. Ưu tiên thay đổi nhỏ nhất đủ để đạt mục tiêu refactor
3. Không đổi public API, query shape, DTO contract, schema, hoặc data mapping nếu user không yêu cầu
4. Không tự ý tách abstraction mới nếu repo đã có abstraction tương đương
5. Nếu refactor có thể ảnh hưởng module khác, phải nêu rõ phạm vi ảnh hưởng trước khi thực hiện
6. Không silent fix thêm các vấn đề khác ngoài phạm vi refactor; nếu có sửa thêm phải nói rõ
7. Nếu rủi ro cao hoặc context chưa đủ, dừng ở mức đề xuất plan thay vì code ngay
8. Sau refactor, phải đọc lại flow chính để chắc không làm lệch hành vi
9. Nếu khu vực có test phù hợp, ưu tiên chạy hoặc cập nhật test để bảo vệ refactor

---

# REFACTOR CHECK

Trước khi kết thúc, tự xác nhận:

1. Refactor không đổi behavior ngoài phần user yêu cầu
2. Phạm vi thay đổi đã được giữ nhỏ nhất có thể
3. Đã nêu rõ mọi thay đổi phụ ngoài mục tiêu chính
4. Không tạo abstraction trùng lặp hoặc architecture mới không cần thiết
