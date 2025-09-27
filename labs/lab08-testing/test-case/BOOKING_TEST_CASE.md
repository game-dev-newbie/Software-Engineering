📑 Booking Module – Test Cases
1. Unit Test Cases
✅ Thành công

- TC-U1: Thêm đặt bàn hợp lệ
- - Input:
  - restaurant = "Nhà hàng A"
  - customer = "Nguyễn Văn B"
  - datetime = "2025-10-01 19:00:00"
  - guests = 4

Expected: Hàm addBooking trả về { success: true, message: "Booking added successfully" }.

❌ Thất bại

TC-U2: Thiếu trường customer

Input: restaurant = "Nhà hàng A", customer = "", datetime = "2025-10-01 19:00:00", guests = 4

Expected: Trả về { success: false, message: "Invalid input" }.

TC-U3: guests <= 0

Input: restaurant = "Nhà hàng A", customer = "Nguyễn Văn B", datetime = "2025-10-01 19:00:00", guests = 0

Expected: { success: false, message: "Invalid input" }.

TC-U4: Lỗi DB (mô phỏng db.query trả lỗi)

Input hợp lệ, nhưng DB trả về lỗi.

Expected: { success: false, message: "Database error" }.

2. Integration Test Cases (MySQL thật)
✅ Thành công

TC-I1: Thêm đặt bàn và kiểm tra DB

Input: restaurant = "Nhà hàng B", customer = "Trần Văn C", datetime = "2025-10-02 20:00:00", guests = 2

Step: POST /bookings

Expected: API trả 200 OK với JSON { success: true } và trong bảng bookings có record tương ứng.

TC-I2: Thêm nhiều đặt bàn liên tiếp

Input: 3 request POST khác nhau

Expected: DB có đúng 3 record, dữ liệu khớp.

❌ Thất bại

TC-I3: Thiếu trường datetime

Input: thiếu datetime

Expected: API trả lỗi 400 Bad Request.

TC-I4: Gửi dữ liệu guests = -5

Input sai quy định

Expected: API trả lỗi { success: false, message: "Invalid input" }.

TC-I5: DB ngắt kết nối (stop MySQL trước khi gọi API)

Input: hợp lệ

Expected: API trả 500 Internal Server Error với { success: false, message: "Database error" }.

3. UI Test Cases (Form đặt bàn)

TC-UI1: Người dùng nhập đầy đủ và bấm "Xác nhận" → Hiện thông báo thành công.

TC-UI2: Để trống "Tên nhà hàng" → Hiện cảnh báo "Vui lòng nhập tên nhà hàng".

TC-UI3: Chọn ngày giờ trong quá khứ → Hiện cảnh báo "Ngày giờ không hợp lệ".

TC-UI4: Nhập số lượng khách = 0 → Hiện cảnh báo "Số lượng khách phải lớn hơn 0".
