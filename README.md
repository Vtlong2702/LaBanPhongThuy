# La Bàn Phong Thủy – Bát Trạch

La bàn cho iPhone: xem hướng hiện tại thuộc cung nào (Khảm, Cấn, Chấn, Tốn, Ly, Khôn, Đoài, Càn) và thuộc **Đông Tứ Trạch** hay **Tây Tứ Trạch**.

| Nhóm | Hướng | Quẻ |
|---|---|---|
| Đông Tứ Trạch | Bắc • Đông • Nam • Đông Nam | Khảm • Chấn • Ly • Tốn |
| Tây Tứ Trạch | Tây • Tây Bắc • Tây Nam • Đông Bắc | Đoài • Càn • Khôn • Cấn |

Mỗi cung rộng 45° (Bắc = 337,5°–22,5°, …). App cũng hiện 24 sơn, hướng tọa (lưng nhà), ngũ hành và có nút khóa hướng.

## Cách dùng
Đặt iPhone nằm ngang, đầu máy hướng ra cửa chính (đứng trong nhà nhìn ra). Tránh xa kim loại, thiết bị điện.

## 1. App iPhone (SwiftUI)
Cần máy Mac có Xcode 16 trở lên, iOS 17 trở lên.
1. Mở `LaBanPhongThuy.xcodeproj` bằng Xcode.
2. Chọn target **LaBanPhongThuy** → *Signing & Capabilities* → chọn Team (Apple ID miễn phí cũng được).
3. Cắm iPhone, chọn iPhone làm đích chạy, bấm ▶︎ Run.
4. Lần đầu: trên iPhone vào *Cài đặt → Cài đặt chung → Quản lý VPN & thiết bị* → tin cậy nhà phát triển.

Simulator không có la bàn, phải chạy trên máy thật.

## 2. Bản web (không cần Mac)
File `docs/index.html`. Bật GitHub Pages: *Settings → Pages → Branch: `main`, thư mục `/docs`*. Mở link trên Safari iPhone, bấm **Bật la bàn** và cho phép truy cập cảm biến. Có thể *Chia sẻ → Thêm vào MH chính* để dùng như app.
