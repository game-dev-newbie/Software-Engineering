// bookingController.js
async function bookTable(req, res) {
  const { restaurant, customer, datetime, guests } = req.body;

  if (!restaurant || !customer || !datetime || !guests || guests <= 0) {
    return res.status(400).json({ message: "Thiếu hoặc sai thông tin" });
  }

  try {
    const sql = "INSERT INTO bookings (restaurant, customer, datetime, guests) VALUES (?, ?, ?, ?)";
    const [result] = await db.query(sql, [restaurant, customer, datetime, guests]);

    return res.status(201).json({
      message: "Đặt bàn thành công",
      bookingId: result.insertId
    });
  } catch (err) {
    return res.status(500).json({ message: "Lỗi server" });
  }
}

module.exports = { bookTable };
