| Mã TC  | Mô tả              | Input                                   | Step                      | Expected                                                                           |
| ------ | ------------------ | --------------------------------------- | ------------------------- | ---------------------------------------------------------------------------------- |
| TC-LI1 | Login thành công   | username="employee1", password="123456" | Gửi form login            | API trả `200 OK`, JSON `{ success: true, token: ... }`                             |
| TC-LI2 | Sai mật khẩu       | username="employee1", password="wrong"  | Gửi form login            | API trả `401 Unauthorized`, `{ success: false, message: "Sai mật khẩu" }`          |
| TC-LI3 | User không tồn tại | username="noone", password="abc"        | Gửi form login            | API trả `404 Not Found`, `{ success: false, message: "Không tìm thấy tài khoản" }` |
| TC-LI4 | Bỏ trống password  | username="employee1", password=""       | Gửi form login            | Frontend hiển thị cảnh báo "Mật khẩu không được để trống"                          |
| TC-LI5 | DB ngắt kết nối    | username="employee1", password="123456" | Gửi form login khi DB tắt | API trả `500 Internal Server Error`                                                |
