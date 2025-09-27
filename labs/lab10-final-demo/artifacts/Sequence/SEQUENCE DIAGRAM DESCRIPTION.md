#Lab03

# Sequence Diagrams - Mini App Zalo Đặt Bàn Nhà Hàng

---

## 1. Luồng khách hàng

### 1.1. Khách hàng đăng nhập tài khoản Zalo + Tìm kiếm & Xem thông tin

- Khách mở Mini App → xác thực qua **Zalo OAuth**.
- Backend kiểm tra token, lưu/đồng bộ thông tin user.
- Người dùng có thể:
  - Tìm kiếm nhà hàng theo thời gian, số khách.
  - Xem chi tiết nhà hàng (menu, giá, đánh giá).
- Lịch sử tìm kiếm được lưu tự động.

![1.1](1.1.%20Khách%20hàng%20đăng%20nhập%20bằng%20tài%20khoản%20Zalo%20+%20Tìm%20kiếm%20&%20xem%20thông%20tin.png)

---

### 1.2. Khách hàng đặt bàn + Đặt cọc

- Khách chọn nhà hàng, thời gian, bàn → gửi yêu cầu đặt.
- Hệ thống giữ slot bàn trong DB.
- Mini App yêu cầu thanh toán cọc:
  - Bằng **QR** hoặc **Card** qua Payment Gateway.
- Khi thanh toán thành công → booking được xác nhận.
- Thông báo gửi tới khách và nhân viên nhà hàng.

![1.2](1.2.%20KH%20đặt%20bàn%20+%20đặt%20cọc.png)

---

### 1.3. Khách hàng check-in

- Khi tới nhà hàng, khách đưa QR booking.
- Nhân viên quét QR để xác nhận.
- Backend kiểm tra trạng thái booking + cọc.
- Nếu hợp lệ → check-in thành công.
- Thông báo đẩy tới khách và cập nhật lịch sử.

![1.3](1.3.%20KH%20check-in.png)

---

### 1.4. Khách hàng hủy & Hoàn tiền

- Khách gửi yêu cầu hủy booking.
- Backend kiểm tra chính sách hoàn cọc (dựa vào thời điểm).
- Nếu đủ điều kiện → hoàn tiền qua Payment Gateway.
- Nếu không đủ → booking hủy nhưng mất cọc.
- Thông báo gửi tới khách.

![1.4](1.4.%20KH%20hủy%20&%20hoàn%20tiền.png)

---

## 2. Staff & Manager

- Nhân viên và quản lý đăng nhập qua **Staff App** riêng.
- Chức năng chính:
  - Tạo booking mới (đặt hộ khách).
  - Lọc bàn theo thời gian.
  - Xác nhận hoặc hủy booking.
  - Check-in khách hàng.
- Riêng **Manager** có thêm:
  - Quản lý bàn, menu, ưu đãi.
  - Quản lý đánh giá, thông tin nhà hàng.
  - Chính sách đặt cọc, hoàn tiền.

![2](2.%20Staff_Manager.png)

---

## 3. Admin

- Đăng nhập qua **Admin Portal**.
- Các chức năng:
  - Quản lý danh sách nhà hàng.
  - Quản lý người dùng & phân quyền.
  - Quản lý thanh toán và liên kết ngân hàng.
  - Quản lý thông báo.
  - Xem báo cáo & thống kê.

![3](3.%20Admin.png)

---

## 4. System Job

- Các tiến trình chạy tự động:
  - **Đồng bộ dữ liệu** (payment status, booking).
  - **Báo cáo hàng ngày**: doanh thu, tỷ lệ hủy, đánh giá.
  - **Nhắc lịch**: gửi thông báo trước giờ ăn.
  - **Cảnh báo full bàn**: gửi socket tới Staff App.

![4](4.%20System%20job.png)

---
