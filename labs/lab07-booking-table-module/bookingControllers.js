const express = require("express");
const db = require("../../src/config/database");

class Booking {
  async getBookingTable(req, res) {
  
    res.render("bookingTable")
  }
}
module.exports = Booking;
