# Nguyên tắc Animation — Triết lý thiết kế

> Tài liệu này trả lời câu hỏi "vì sao" và "khi nào". Dùng để đọc một lần lúc onboard,
> hoặc tham khảo khi cần quyết định về mặt thiết kế/UX cho animation.
> Với checklist tra cứu nhanh khi code/review PR, xem `animation-checklist.md`.

## Mục đích

Định nghĩa nguyên tắc để thiết kế và triển khai animation chất lượng cao trên web,
áp dụng cho: UI animation, page transition, component interaction, scroll-driven
animation, micro-interaction, và hệ thống motion của toàn bộ giao diện.

Mục tiêu **không phải** là tạo ra càng nhiều animation càng tốt, mà là tạo ra
chuyển động **có chủ đích, nhất quán, phản hồi tốt, hiệu năng cao, dễ tiếp cận**.

---

## Priority — thứ tự ưu tiên khi có xung đột

Không phải mọi nguyên tắc trong tài liệu này có cùng mức độ quan trọng. Khi
hai nguyên tắc mâu thuẫn nhau, xử lý theo thứ tự sau (cao → thấp):

1. **Accessibility / usability** — `prefers-reduced-motion`, không phá chức
   năng, không phụ thuộc hover cho hành động quan trọng.
2. **Correctness** — cleanup đúng cách, không leak timeline/listener, không
   để animation chạy sau khi component bị destroy, không phá behavior/API
   hiện có ngoài phạm vi task.
3. **Performance** — ưu tiên `transform`/`opacity`, tránh layout thrashing.
4. **Convention hiện tại của project** — pattern/utility animation đã có sẵn.
5. **Visual consistency** — hierarchy, hướng chuyển động, logic không gian.
6. **Motion polish** — timing cụ thể, kiểu easing, mức độ bounce/stagger.

Nói cách khác: **cứng — không thương lượng** là (1)–(3); **mềm — điều chỉnh
theo gu thẩm mỹ/brand/convention** là (4)–(6). Khi một chi tiết polish (vd.
easing, bounce) mâu thuẫn với convention sẵn có của project, ưu tiên
convention và bàn thay đổi riêng — đừng tự ý phá vỡ tính nhất quán trong một
PR đơn lẻ.

---

## 1. Animation là một hình thức giao tiếp

Animation phải truyền tải một ý nghĩa nào đó: thứ bậc thị giác, quan hệ nguyên
nhân – kết quả, quan hệ không gian, thay đổi trạng thái, phản hồi hệ thống, tính
liên tục, trọng tâm, tiến trình.

Không thêm animation chỉ vì một element *có thể* được animate. Mỗi animation
quan trọng phải có mục đích rõ ràng — nếu bỏ animation mà không làm giảm khả
năng sử dụng hay hiểu giao diện, hãy xem lại liệu nó có thực sự cần thiết.

## 2. Hiểu giao diện trước khi thiết kế animation

Trước khi triển khai: kiểm tra UI hiện tại, xác định thứ bậc thị giác chính và
hành động người dùng dự kiến, kiểm tra pattern/utility animation đang dùng,
behavior responsive, yêu cầu accessibility, giới hạn performance.

Không thiết kế animation tách biệt khỏi giao diện — motion phải củng cố thiết
kế hiện tại thay vì cạnh tranh với nó.

## 3. Xây dựng thứ bậc chuyển động

Không phải element nào cũng nên có mức độ animation giống nhau:

- **Primary** — cần thu hút chú ý trước tiên: tiêu đề trang, CTA chính, hình
  ảnh sản phẩm chính, trạng thái quan trọng, kết quả của interaction chính.
- **Secondary** — hỗ trợ nội dung chính: description, metadata, control phụ.
- **Tertiary** — trang trí / hoàn thiện: element trang trí, ambient effect.

Primary nên có ưu tiên motion cao hơn. Không animate mọi element cùng cường độ.

## 4. Thiết kế choreography trước khi implementation

Xem animation như một chuỗi chuyển động, không phải hiệu ứng độc lập. Xác định:
trạng thái ban đầu → trigger → chuyển động đầu tiên → chuyển động hỗ trợ →
điểm nhấn chính → trạng thái ổn định cuối cùng.

Mỗi delay phải đóng góp vào hierarchy, quan hệ nguyên nhân – kết quả, hoặc
rhythm — tránh delay tùy tiện.

## 5. Timing

Timing truyền tải mức độ quan trọng và cảm giác vật lý của chuyển động. Không
dùng cùng một duration cho các element không liên quan.

| Loại animation           | Khoảng thời gian |
| ------------------------ | ----------------: |
| Micro interaction         | 100–200ms |
| State transition nhỏ      | 150–300ms |
| Component entrance        | 250–500ms |
| Chuỗi entrance phức tạp    | 500–1200ms |
| Visual transition lớn     | 400–1000ms |

Đây là điểm khởi đầu tham khảo, không phải quy tắc cứng — điều chỉnh theo
khoảng cách chuyển động, độ phức tạp, hierarchy và ngữ cảnh tương tác. Không
được đánh đổi UX hoặc visual intent chỉ để nằm trong range.

## 6. Easing

Easing thể hiện đặc tính của chuyển động (phản hồi nhanh, mượt, nặng, nhẹ, có
tính vật lý, vui nhộn, năng động, tiết chế...). Không dùng cùng một easing cho
mọi animation.

Acceleration/deceleration rõ hơn cho chuyển động lớn; easing nhẹ cho
micro-interaction. Tránh bounce/elastic quá mức trừ khi visual language của
sản phẩm thực sự yêu cầu.

## 7. Stagger, hướng chuyển động và tính liên tục

**Stagger** tạo hierarchy và rhythm — dùng khi nhiều element tạo thành một
sequence hoặc cần reveal tuần tự. Tránh khi nó làm nội dung quan trọng xuất
hiện quá muộn, các element không liên quan nhau, hoặc trở nên lặp lại nhàm chán.

**Hướng chuyển động** phải có ý nghĩa: từ dưới lên có thể biểu thị tiếp nối;
từ bên cạnh biểu thị chuyển động không gian; scale biểu thị tập trung/nhấn
mạnh; fade biểu thị xuất hiện/biến mất. Duy trì logic không gian nhất quán —
nếu element exit sang trái, đừng cho destination liên quan xuất hiện từ hướng
ngược lại mà không có lý do.

**Tính liên tục** — animation nên giúp người dùng hiểu: element này đến từ
đâu, đang đi đâu, điều gì gây ra thay đổi trạng thái, mối quan hệ giữa hai
trạng thái là gì. Ưu tiên transition giải thích sự thay đổi thay vì hiệu ứng
thị giác không liên quan.

## 8. Phản hồi tương tác

Element có thể tương tác (hover, focus, active, pressed, selected, expanded,
loading, success, error...) phải cung cấp phản hồi phù hợp và kịp thời. Mức độ
phản hồi phải tương xứng với hành động — một click button không cần cinematic
animation trừ khi interaction đó thực sự yêu cầu.

**Hover/pointer**: nên phản hồi nhanh, reversible, tinh tế, có thể bị ngắt.
Không tạo animation mới cho mỗi pointer event — ưu tiên điều khiển animation
hiện tại hoặc chuyển state. Không phụ thuộc hoàn toàn vào hover cho chức năng
quan trọng (touch device không có hover truyền thống).

## 9. Scroll-driven animation

Scroll animation phải hỗ trợ nội dung, không chống lại hành động scroll của
người dùng.

Ưu tiên: parallax nhẹ, progressive reveal, pinned storytelling khi thực sự
cần, section transition, visual continuity.

Tránh: can thiệp quá mức vào scroll, animation khiến nội dung khó đọc, pinned
section quá dài, animation cản trở navigation. Người dùng phải luôn cảm thấy
mình kiểm soát việc scroll.

## 10. Tiết chế về mặt thị giác

Nhiều animation hơn **không** đồng nghĩa với animation tốt hơn.

Tránh: bounce không cần thiết, rotation/scale quá mức, chuyển động liên tục,
animate mọi element, nhiều focal point cạnh tranh nhau, decorative motion gây
mất tập trung.

Một giao diện được thiết kế tốt thường dùng **ít** motion hơn giao diện
amateur. Ưu tiên **một chuyển động mạnh và có chủ đích** thay vì mười chuyển
động không liên quan.

Điều này áp dụng cả cho stagger (đừng dùng cùng một giá trị cho mọi trường
hợp) và cho pattern lặp lại như "fade in + translateY + delay" áp cho mọi
component một cách máy móc.

## 11. Rhythm của animation

Xem xét: anticipation, acceleration, deceleration, pause, overlap, repetition,
contrast. Không phải animation nào cũng cần bắt đầu/kết thúc độc lập — overlap
giữa các sequence có thể tạo rhythm tự nhiên hơn. Tránh làm mọi animation
đồng bộ hoàn toàn.

---

## Nguyên tắc cốt lõi

Đừng hỏi:

> "Làm thế nào để animate element này?"

Hãy hỏi:

> "Khi state này thay đổi, người dùng cần hiểu hoặc cảm nhận điều gì?"

Sau đó chọn chuyển động đơn giản nhất có thể truyền tải chính xác ý định đó.

**Animation thành công khi người dùng cảm nhận được trải nghiệm, thay vì
nhận ra implementation phía sau nó.**
