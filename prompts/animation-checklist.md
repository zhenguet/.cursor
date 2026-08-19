# Animation — Checklist thực thi

> Dùng để tra cứu nhanh khi code hoặc review PR có animation.
> Với phần triết lý/nguyên tắc thiết kế, xem `animation-principles.md`.

## Conditional dependencies

- `vercel-react-view-transitions` — only when the task implements or reviews route/page transitions or shared-element transitions in React/Next.

Do not load the view-transition skill for ordinary component micro-interactions.

## Trước khi viết code

1. Kiểm tra implementation hiện tại trong component/module liên quan.
2. Tìm các animation tương tự đã tồn tại trong repo (vd. `animations/`, hook
   dùng chung, component tương tự khác) trước khi thiết kế cái mới. Ưu tiên
   reuse pattern hiện có nếu nó giải quyết được cùng vấn đề — không tạo
   animation utility mới chỉ vì task nghe như "mới".
3. Xác định trigger, choreography, timing, easing.
4. Xác định responsive behavior và reduced-motion behavior.
5. Xác định yêu cầu cleanup (unmount, route change, viewport change).

Sau đó triển khai kiến trúc **nhỏ nhất có thể** để tạo ra animation mong muốn.
Không tạo abstraction không cần thiết, không sửa code không liên quan, không
thêm dependency nếu không có lý do chính đáng.

## Performance

- Ưu tiên animate `transform` và `opacity`.
- Tránh: recalculation layout không cần thiết, DOM measurement loop,
  đọc/ghi DOM đồng bộ lặp lại, animate quá nhiều DOM node, cập nhật React
  state theo từng animation frame.
- Animation không được ảnh hưởng đến scrolling, khả năng phản hồi input,
  rendering performance, hoặc mức tiêu thụ pin.

## Tích hợp React

- Tách animation state khỏi application state khi có thể.
- Tránh cập nhật React state ở mỗi animation frame.
- Scope animation theo component; cleanup timeline và listener khi unmount.
- Tránh re-render không cần thiết; tái sử dụng animation utility hiện có.
- Ưu tiên animation library imperative (vd. GSAP) cho animation tần suất cao
  thay vì điều khiển từng frame qua React state.

## Dùng GSAP (khi project đã có GSAP)

**GSAP là implementation tool, không phải design principle.** Luôn xuất phát
từ animation-principles.md trước, chọn GSAP feature sau — không đảo ngược.

- Dùng theo architecture hiện tại của project — không tự ý đổi kiến trúc.
- Ưu tiên `timeline` cho sequence có phối hợp; dùng label khi giúp code dễ đọc.
- Dùng stagger khi nó phục vụ hierarchy, không phải mặc định.
- Trong React: dùng `gsap.context()` hoặc cơ chế cleanup hiện tại của project.
- Dùng `gsap.matchMedia()` khi behavior khác nhau có ý nghĩa giữa các viewport.
- Không đưa GSAP vào nếu project đã có giải pháp phù hợp, trừ khi có lý do
  kỹ thuật/thị giác rõ ràng. Không dùng feature chỉ vì nó tồn tại.

## Khả năng bị ngắt (interruption)

Interactive animation phải xử lý tốt: click liên tục, hover liên tục,
navigation trong lúc animation chạy, component unmount, route change,
viewport change.

- Không để animation tiếp tục chạy sau khi component đã bị destroy.
- Không để tích lũy timeline, event listener, observer, callback.

## Responsive

- Mobile thường cần: sequence ngắn hơn, khoảng cách chuyển động nhỏ hơn, ít
  effect đồng thời hơn, parallax nhẹ hơn, choreography đơn giản hơn.
- Không lấy giá trị desktop rồi scale xuống — thiết kế riêng cho mobile/touch.

## Accessibility

- Luôn tôn trọng `prefers-reduced-motion`.
- Khi reduced motion bật: loại bỏ chuyển động không cần thiết, giảm transform
  lớn, tránh parallax quá mức — nhưng **vẫn duy trì** state change có ý nghĩa,
  usability, và visual hierarchy. Reduced motion không có nghĩa là interaction
  bị hỏng.

## Không phá existing behavior / API

Task animation phải giữ nguyên phạm vi. Cụ thể:

- Không thay đổi behavior không liên quan đến animation.
- Không thay đổi layout, content, hoặc accessibility semantics nếu task
  không yêu cầu.
- Không thay đổi public API của component (props, event, DOM structure)
  nếu không thực sự cần thiết cho animation.

Ví dụ: task "add hover animation to Button" không nên kéo theo sửa API của
Button, đổi cấu trúc DOM, hay động vào state management không liên quan.

## Failure behavior

Animation không được làm hỏng ứng dụng khi nó thất bại:

- Animation failure không được block interaction hoặc business logic bên
  dưới nó.
- Animation nên degrade gracefully khi animation API không khả dụng.
- Business logic không phụ thuộc vào việc animation hoàn thành, trừ khi
  animation thực sự là một phần bắt buộc của flow (hiếm khi đúng). Mặc định:
  business action và animation chạy song song/độc lập tương đối, không phải
  `onClick → animation → onComplete → business action`.

## Visual Validation (khi có môi trường preview)

Không coi animation là hoàn thành chỉ dựa trên đọc code. Khi có công cụ chạy
dev server / browser preview trong phiên làm việc:

- Chạy trang/component liên quan và quan sát animation ở môi trường render
  thật.
- Kiểm tra trạng thái ban đầu và trạng thái cuối.
- Kiểm tra animation ở tốc độ tương tác bình thường, và khi tương tác lặp lại.
- Kiểm tra ở mobile viewport và với reduced-motion bật.
- So sánh với reference/design nếu có.

Nếu không có công cụ preview trong phiên làm việc, bỏ qua bước này — đừng coi
đây là điều kiện chặn commit, chỉ áp dụng khi thực sự khả thi.

## Trước khi chọn animation cho một component mới

1. Người dùng cần tập trung vào đâu?
2. Điều gì vừa thay đổi?
3. Mối quan hệ nào cần được truyền tải?
4. Hướng chuyển động nào có ý nghĩa?
5. Cần chuyển động với mức độ bao nhiêu?
6. Element này có thực sự cần animation không?

Dùng chuyển động đơn giản nhất có thể truyền tải hiệu quả behavior mong muốn.

---

## Definition of Done

### Design

- [ ] Animation có mục đích rõ ràng.
- [ ] Visual hierarchy có chủ đích (Primary/Secondary/Tertiary).
- [ ] Timing và easing phù hợp với chuyển động.
- [ ] Stagger có mục đích, không phải mặc định.
- [ ] Hướng chuyển động nhất quán với logic không gian hiện có.

### Engineering

- [ ] Component cleanup animation đúng cách (unmount, route change).
- [ ] Tương tác lặp lại không tạo ra conflict/timeline chồng chéo.
- [ ] Responsive behavior đã được xem xét (mobile/touch).
- [ ] `prefers-reduced-motion` được hỗ trợ.
- [ ] Performance ở mức chấp nhận được (không layout thrashing).
- [ ] Animation failure không block business logic bên dưới.
- [ ] Không thay đổi behavior/API ngoài phạm vi task.
- [ ] Không thêm dependency không cần thiết.
- [ ] Tuân thủ convention hiện tại của project.

### Verification

- [ ] Type checking pass.
- [ ] Linting pass.
- [ ] Các test liên quan pass.
- [ ] Visual behavior đã được kiểm tra nếu môi trường cho phép.
- [ ] Final diff không chứa thay đổi không liên quan.

## Đánh giá chất lượng thị giác (review nhanh)

| Khía cạnh | Câu hỏi kiểm tra |
| --- | --- |
| Timing | Có quá nhanh/chậm không? Delay có ý nghĩa không? |
| Hierarchy | Attention người dùng có được dẫn đúng không? Element chính có ưu tiên? |
| Easing | Chuyển động có tự nhiên, phù hợp với loại chuyển động không? |
| Rhythm | Các sequence có phối hợp tốt? Stagger/overlap có chủ đích? |
| Stability | Final state có ổn định? Có chuyển động thừa sau khi hoàn thành? |
| Interaction | Tương tác lặp lại có mượt? Animation có thể bị ngắt an toàn? |
| Responsive | Hoạt động tốt trên mobile/touch/các viewport khác nhau? |
| Accessibility | Reduced motion hoạt động đúng? |
| Performance | Animation có mượt? Có render/layout calculation thừa không? |
