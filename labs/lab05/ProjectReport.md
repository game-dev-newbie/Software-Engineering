# Project Report – Mini App Zalo Đặt Bàn Nhà Hàng

## 1. Giới thiệu dự án
- **Tên**: Mini App Zalo Đặt Bàn Nhà Hàng  
- **Mục tiêu**: Xây dựng một mini app trên nền Zalo giúp khách hàng đặt bàn tại các nhà hàng yêu thích, đồng thời hỗ trợ nhân viên và quản lý nhà hàng xử lý đặt bàn, quản lý thực đơn, ưu đãi và phản hồi.  
- **Quy mô**: Bài tập học tập (lab) – mức độ triển khai cơ bản nhưng đầy đủ luồng chính.  

---

## 2. Artifacts đã xây dựng

### 2.1. Use Case Diagrams
- **Customer**: đăng nhập, tìm kiếm, xem thông tin, đặt bàn, thanh toán cọc, check-in, hủy/hoàn tiền, đánh giá.  
- **Staff**: tạo booking, xác nhận/hủy, check-in khách.  
- **Manager**: quản lý menu, bàn, ưu đãi, đánh giá, chính sách đặt cọc.  
- **Admin**: quản lý hệ thống (người dùng, thanh toán, báo cáo).  
- **System**: đồng bộ dữ liệu, gửi thông báo, sinh báo cáo tự động.  

### 2.2. Sequence Diagrams
Theo mô tả trong file `SEQUENCE DIAGRAM DESCRIPTION.md`:  
- Khách hàng đăng nhập qua Zalo OAuth → tìm kiếm nhà hàng → đặt bàn + thanh toán cọc → check-in → hủy/hoàn tiền.  
- Staff & Manager đăng nhập qua app riêng, quản lý booking, bàn, menu, ưu đãi.  
- Admin đăng nhập qua portal quản lý, theo dõi thống kê.  
- System job chạy tự động: đồng bộ thanh toán, gửi nhắc lịch, cảnh báo full bàn.  

### 2.3. Form Login Code
- **Frontend**: file `index.html`, `styles.css`, `main.js` với form đăng nhập (username/password).  
- **Backend**: module xử lý POST request, kết nối MySQL, lưu thông tin user.  
- Đã viết **unit test** (Jest) và **integration test** (Selenium) cho form login và đặt bàn.  

### 2.4. ERD & Database
- Thực thể chính: Users, Restaurants, Tables, Bookings, Payments, Reviews, Notifications, Promotions, Audit Logs.  
- SQL script tạo DB đã được viết (`restaurant_booking.sql`).  

---

## 3. Quy trình làm việc

1. **Phân tích yêu cầu**:  
   - Xác định actors (customer, staff, manager, admin, system).  
   - Lập use case, sequence diagram để mô tả nghiệp vụ.  

2. **Thiết kế hệ thống**:  
   - Thiết kế ERD và ràng buộc quan hệ.  
   - Định nghĩa module backend (Express + MySQL).  
   - Lên UI cơ bản (HTML/CSS/JS).  

3. **Lập trình & tích hợp**:  
   - Viết module đặt bàn (API POST → MySQL).  
   - Viết form login frontend + kết nối backend.  
   - Viết unit test bằng Jest cho booking.  
   - Viết integration test bằng Selenium cho login form.  

4. **Quản lý source code**:  
   - Sử dụng Git/GitHub để quản lý.  
   - Commit theo từng giai đoạn (design, backend, frontend, test).  
   - Tag version v1.0 sau khi hoàn thiện.  

5. **Kiểm thử**:  
   - Unit test: xác minh hàm xử lý dữ liệu booking.  
   - Integration test: test form login, test flow đặt bàn.  
   - Manual test: UI, database, thông báo.  

6. **Báo cáo**:  
   - Tổng hợp artifacts, test case, code.  
   - Viết Project Report (file Markdown/PDF).  

---

## 4. Hướng dẫn push code & tạo tag version

```bash
# Cấu hình lần đầu
git config --global user.name "Tên của bạn"
git config --global user.email "email@example.com"

# Thêm remote
git remote add origin https://github.com/username/repo.git

# Push code
git add .
git commit -m "Hoàn thiện v1.0 - Mini app đặt bàn nhà hàng"
git push origin main

# Tạo tag v1.0
git tag v1.0
git push origin v1.0
```

---

## 5. Kết luận
Dự án đã hoàn thành đúng yêu cầu Lab: từ phân tích, thiết kế, lập trình, kiểm thử đến báo cáo. Hệ thống mini app có thể mở rộng thêm nhiều chức năng thực tế (Zalo OAuth thật, Payment Gateway, CI/CD).  
