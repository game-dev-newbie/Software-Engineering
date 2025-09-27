const express = require("express");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Kết nối MySQL
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  port: 3306,
  password: "123456", // điền mật khẩu MySQL của bạn
  database: "restaurant_booking"
});

db.connect(err => {
  if (err) throw err;
  console.log("✅ Đã kết nối MySQL");
});

// API đặt bàn
app.post("/bookings", (req, res) => {
  const { restaurant, customer, datetime, guests } = req.body;

  if (!restaurant || !customer || !datetime || !guests) {
    return res.status(400).json({ message: "Thiếu thông tin đặt bàn!" });
  }

  const sql = "INSERT INTO bookings (restaurant, customer, datetime, guests) VALUES (?, ?, ?, ?)";
  db.query(sql, [restaurant, customer, datetime, guests], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Lỗi server!" });
    }
    res.json({ message: "Đặt bàn thành công!", bookingId: result.insertId });
  });
});

// Chạy server
app.listen(3000, () => {
  console.log("🚀 Server chạy tại http://localhost:3000");
});
