# Final Report: Mini App Đặt Bàn Nhà Hàng

## 1. Giới thiệu dự án

Mini App Đặt Bàn Nhà Hàng là một ứng dụng học tập (lab) nhằm mô phỏng quy trình đặt bàn online cho nhà hàng thông qua UI khách hàng và các vai trò bên trong nhà hàng. Mục tiêu:

- Cho khách xem thông tin nhà hàng, đặt bàn, thanh toán cọc, check-in, hủy / đánh giá.  
- Cho nhân viên lễ tân / quản lý xử lý booking, quản lý bàn, quản lý menu, xác nhận / hủy đặt bàn.  
- Cung cấp các công cụ test (unit, integration) để đảm bảo tính đúng đắn.  
- Dùng các mô hình UML (Use Case, Sequence, ERD) để thiết kế hệ thống trước khi lập trình.

Ứng dụng này không phải app production hoàn chỉnh, mà là bản demo để học các mô hình hệ thống, tích hợp, kiểm thử.

---

## 2. Các mô hình UML & Database

### 2.1 Use Case Diagram (tóm lược)

- **Khách hàng (Customer)**  
  - Đăng nhập  
  - Tìm kiếm nhà hàng  
  - Xem thông tin / menu / đánh giá  
  - Đặt bàn  
  - Thanh toán cọc  
  - Check-in / hủy  
  - Đánh giá  
  - Xem lịch sử booking  

- **Nhân viên lễ tân (Staff)**  
  - Đăng nhập  
  - Tạo đặt bàn mới  
  - Xác nhận / hủy booking  
  - Check-in khách  
  - Gửi thông báo khách  

- **Quản lý (Manager)**  
  - Tất cả quyền của lễ tân  
  - Quản lý menu  
  - Quản lý bàn  
  - Quản lý đánh giá / ưu đãi  
  - Cài chính sách đặt cọc / hoàn tiền  

- **Admin hệ thống**  
  - Đăng nhập  
  - Quản lý nhà hàng  
  - Quản lý nhân viên  
  - Quản lý báo cáo, thanh toán, thông báo  

- **System (hệ thống nội bộ / jobs nền)**  
  - Xác thực tài khoản  
  - Đồng bộ dữ liệu  
  - Xử lý tìm kiếm  
  - Xử lý đặt bàn / thanh toán backend  
  - Tạo báo cáo tự động  
  - Gửi thông báo tự động  

### 2.2 Sequence Diagrams

- Flow đăng nhập + tìm kiếm + đặt bàn + thanh toán cọc + check-in  
- Flow Staff / Manager xác nhận / hủy  
- Flow System job gửi nhắc lịch, đồng bộ thanh toán  

### 2.3 ERD / Database & script SQL

Dựa trên các mô hình, mình đã định nghĩa các bảng chính và mối quan hệ:

- **users** (user_id, username, password_hash, role, name, phone, email, ...)  
- **restaurants** (restaurant_id, name, address, phone, google_place_id, ...)  
- **restaurant_tables** (table_id, restaurant_id, capacity, status, ...)  
- **bookings** (booking_id, restaurant_id, customer_id, table_id, booking_time, guest_count, status, deposit_amount, ...)  
- **payments** (payment_id, booking_id, amount, method, status, transaction_time, ...)  
- **reviews** (review_id, booking_id, customer_id, rating, comment, ...)  
- **notifications** (notification_id, user_id, restaurant_id, content, type, status, ...)  
- **promotions** (promotion_id, restaurant_id, title, discount_percent, start_date, end_date, ...)  
- **audit_logs** (log_id, actor_user_id, action, entity, entity_id, details, created_at)

---

## 3. Code SQL minh họa

```sql
CREATE TABLE `bookings` (
  `booking_id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `customer_id` INT NULL,
  `table_id` INT NULL,
  `booking_time` DATETIME NOT NULL,
  `guest_count` INT NOT NULL,
  `status` ENUM('pending','confirmed','cancelled','checked_in','no_show') DEFAULT 'pending',
  `deposit_amount` DECIMAL(12,2) DEFAULT 0.00,
  `created_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (`restaurant_id`),
  INDEX (`customer_id`),
  INDEX (`status`)
);
```

Và các `FOREIGN KEY` như:

```sql
ALTER TABLE bookings
  ADD CONSTRAINT fk_booking_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
    ON DELETE CASCADE;
```

---

## 4. Kết quả chạy test

### 4.1 Unit Test (booking module)

- Đặt bàn hợp lệ → trả `201` + `bookingId`  
- Thiếu trường → trả `400` với thông báo lỗi  
- Lỗi DB → trả `500`  

Ví dụ test case:

```js
test("Đặt bàn thành công", async () => {
  req.body = { restaurant, customer, datetime, guests: 4 };
  mockDb.query.mockResolvedValueOnce([{ insertId: 123 }]);
  await bookTable(req, res);
  expect(res.status).toHaveBeenCalledWith(201);
  expect(res.json).toHaveBeenCalledWith({
    message: "Đặt bàn thành công",
    bookingId: 123
  });
});
```

### 4.2 Integration Test (login form)

- Script Selenium mở browser, nhập `username` + `password`, bấm login.  
- Timeout 10 giây để chờ alert/error box.  
- Kết quả test:

```
1) TC-LI1: Passed  
2) TC-LI4: Passed  
3) Toggle password: Passed  
4) Remember & Cancel: Passed  
All UI tests finished successfully.
```

---

## 5. Kết luận & định hướng mở rộng

### Kết luận

- Dự án mini app đã tích hợp các bước: thiết kế UML → triển khai schema DB → backend + frontend → kiểm thử unit & integration.  
- Mô hình dữ liệu hợp lý, có thể mở rộng, có audit và thông báo.  
- Test bao phủ logic (unit) và UI login (integration).  
- Đây là phiên bản v1.0 demo đủ để kiểm tra chức năng đặt bàn cơ bản.

### Định hướng mở rộng

1. Tích hợp **Zalo OAuth** cho login thật.  
2. Thanh toán thực tế với **cổng MoMo / ZaloPay / ngân hàng**.  
3. Quản lý đa chi nhánh, phân quyền chi tiết owner/manager/staff.  
4. Thời gian thực (WebSocket) để cập nhật trạng thái bàn.  
5. API tích hợp partner qua webhook.  
6. Tối ưu hiệu năng & cache.  
7. UI mobile-first đẹp hơn.  
8. CI/CD và pipeline test tự động.  
9. Monitoring & alert khi lỗi.  
10. Cải thiện bảo mật, rate limit, xác thực hai lớp.
