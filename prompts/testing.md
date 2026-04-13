# TESTING PROMPT

Chỉ đọc file này khi task liên quan test.

Áp dụng cho:

- viết test mới
- sửa test cũ
- review test coverage
- đề xuất test cases

Nếu test cho Backend, phải đọc thêm `@.cursor/prompts/backend.md`.
Nếu test cho Frontend, phải đọc thêm `@.cursor/prompts/frontend.md`.
Nếu test phát sinh từ refactor, phải đọc thêm `@.cursor/prompts/refactor-safe.md`.

---

# TEST STRATEGY

1. Viết test đúng style repo hiện tại, không áp framework hoặc pattern mới nếu repo chưa dùng
2. Luôn đọc code đang được test trước khi viết test
3. Đọc các test gần nhất hoặc test cùng module để bám naming, setup, fixture, và assertion style
4. Chỉ thêm test khi regression risk đủ đáng kể hoặc user yêu cầu rõ
5. Không over-test, không viết test hình thức, không test lại implementation detail nếu không có giá trị bảo vệ hành vi
6. Ưu tiên test behavior, contract, và edge case có rủi ro thật
7. Nếu repo đã có utility, fixture, helper, base spec, hoặc test setup dùng chung, phải tái sử dụng
8. Không tự ý thêm test framework, test utility, mocking style, hoặc snapshot pattern mới nếu repo chưa dùng
9. Nếu chưa có test nào thật sự đáng viết, phải nói rõ thay vì cố tạo test cho đủ

---

# CONTEXT DISCOVERY

Theo `mode`, tối thiểu phải đọc:

1. Code production đang được test
2. Test gần nhất hoặc test cùng module
3. Test utility, fixture, base class/spec, hoặc helper dùng chung nếu có
4. Spec, edge case, hoặc bug report liên quan

Trong `debug mode`, phải phân biệt rõ:

- test để tái hiện bug
- test để xác nhận fix

Không viết test đại khái khi chưa hiểu hành vi mong muốn.

---

# BACKEND TEST NOTES

Nếu task là Backend test:

1. Bám pattern test hiện tại của repo
2. Ưu tiên framework đang dùng sẵn trong khu vực đó
3. Nếu module hiện tại dùng Spock/Testcontainers/integration style, không tự ý đổi sang style khác
4. Không over-mock nếu khu vực đó đang thiên về integration test

---

# FRONTEND TEST NOTES

Nếu task là Frontend test:

1. Bám framework và style đang có trong repo
2. Không tạo test quá gắn với implementation detail của component nếu behavior mới là thứ cần bảo vệ
3. Không thêm mock phức tạp hoặc test setup mới nếu repo đã có shared helper tương đương

---

# TEST CHECK

Trước khi kết thúc, tự xác nhận:

1. Đã đọc code production và test cùng khu vực
2. Test mới bám style repo hiện tại
3. Test có giá trị bảo vệ hành vi thật, không chỉ tăng số lượng
4. Không tạo thêm test utility/framework không cần thiết
