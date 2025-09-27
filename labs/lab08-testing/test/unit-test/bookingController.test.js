const { bookTable } = require("./bookingController");

describe("Unit Test: bookTable", () => {
  let req, res, mockDb;

  beforeEach(() => {
    req = { body: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    // mock db
    mockDb = { query: jest.fn() };
    global.db = mockDb; // giả lập db
  });

  test("Đặt bàn thành công", async () => {
    req.body = {
      restaurant: "Nhà hàng A",
      customer: "Nguyễn Văn B",
      datetime: "2025-09-30 19:00:00",
      guests: 4,
    };

    mockDb.query.mockResolvedValueOnce([{ insertId: 1 }]);

    await bookTable(req, res);

    expect(res.status).toHaveBeenCalledWith(201);
    expect(res.json).toHaveBeenCalledWith({
      message: "Đặt bàn thành công",
      bookingId: 1,
    });
  });

  test("Thiếu thông tin (customer)", async () => {
    req.body = {
      restaurant: "Nhà hàng A",
      datetime: "2025-09-30 19:00:00",
      guests: 4,
    }; // thiếu customer

    await bookTable(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      message: "Thiếu hoặc sai thông tin",
    });
  });

  test("Số khách không hợp lệ", async () => {
    req.body = {
      restaurant: "Nhà hàng A",
      customer: "Nguyễn Văn B",
      datetime: "2025-09-30 19:00:00",
      guests: 0,
    };

    await bookTable(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      message: "Thiếu hoặc sai thông tin",
    });
  });

  test("Lỗi database", async () => {
    req.body = {
      restaurant: "Nhà hàng A",
      customer: "Nguyễn Văn B",
      datetime: "2025-09-30 19:00:00",
      guests: 4,
    };

    mockDb.query.mockRejectedValueOnce(new Error("DB error"));

    await bookTable(req, res);

    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith({ message: "Lỗi server" });
  });
});
