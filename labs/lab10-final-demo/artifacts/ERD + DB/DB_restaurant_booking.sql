-- tạo database
CREATE DATABASE IF NOT EXISTS restaurant_booking
  CHARACTER SET = 'utf8mb4'
  COLLATE = 'utf8mb4_unicode_ci';
USE restaurant_booking;


-- ----------------------------------------------------------------
-- Bảng users: chứa customer, staff, manager, admin
-- role: 'customer' | 'staff' | 'manager' | 'admin'
-- ----------------------------------------------------------------
CREATE TABLE `users` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NULL,
  `password_hash` VARCHAR(255) NULL,
  `role` ENUM('customer','staff','manager','admin') NOT NULL DEFAULT 'customer',
  `name` VARCHAR(200) NULL,
  `phone` VARCHAR(32) NULL,
  `email` VARCHAR(255) NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_users_email` (`email`),
  UNIQUE KEY `uq_users_phone` (`phone`),
  INDEX (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Bảng restaurants
-- ----------------------------------------------------------------
CREATE TABLE `restaurants` (
  `restaurant_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `address` VARCHAR(512) NULL,
  `phone` VARCHAR(32) NULL,
  `google_place_id` VARCHAR(128) NULL,
  `open_hours` TEXT NULL, -- có thể lưu JSON/text
  `rating_avg` DECIMAL(3,2) NULL DEFAULT NULL,
  `is_partner` TINYINT(1) NOT NULL DEFAULT 1,
  `created_by` INT NULL, -- FK -> users.user_id (owner/manager who onboarded)
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_restaurants_phone` (`phone`),
  INDEX (`created_by`),
  INDEX (`google_place_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- nếu muốn ràng buộc created_by:
ALTER TABLE `restaurants`
  ADD CONSTRAINT `fk_restaurants_created_by` FOREIGN KEY (`created_by`) REFERENCES `users`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Bảng tables (bàn trong nhà hàng)
-- ----------------------------------------------------------------
CREATE TABLE `restaurant_tables` (
  `table_id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `table_number` VARCHAR(50) NULL,
  `capacity` INT NOT NULL DEFAULT 2,
  `status` ENUM('available','reserved','disabled') NOT NULL DEFAULT 'available',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (`restaurant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `restaurant_tables`
  ADD CONSTRAINT `fk_tables_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Bảng bookings
-- ----------------------------------------------------------------
CREATE TABLE `bookings` (
  `booking_id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `customer_id` INT NULL,
  `table_id` INT NULL,
  `booking_time` DATETIME NOT NULL,        -- thời điểm khách muốn check-in
  `created_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `guest_count` INT NOT NULL DEFAULT 1,
  `status` ENUM('pending','confirmed','cancelled','no_show','checked_in') NOT NULL DEFAULT 'pending',
  `deposit_amount` DECIMAL(12,2) NULL DEFAULT 0.00,
  `source` VARCHAR(50) NULL, -- ví dụ 'miniapp', 'phone', 'google'
  `note` TEXT NULL,
  `created_by` INT NULL, -- user who created booking (maybe staff or customer)
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (`restaurant_id`),
  INDEX (`customer_id`),
  INDEX (`table_id`),
  INDEX (`status`),
  INDEX (`booking_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_customer` FOREIGN KEY (`customer_id`) REFERENCES `users`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_table` FOREIGN KEY (`table_id`) REFERENCES `restaurant_tables`(`table_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Bảng payments
-- Một booking có thể có nhiều giao dịch (cọc, hoàn tiền, ...)
-- ----------------------------------------------------------------
CREATE TABLE `payments` (
  `payment_id` INT AUTO_INCREMENT PRIMARY KEY,
  `booking_id` INT NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `method` ENUM('card','qr','bank_transfer','cash') NOT NULL,
  `status` ENUM('pending','paid','refunded','failed') NOT NULL DEFAULT 'pending',
  `transaction_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `provider_ref` VARCHAR(255) NULL,
  `note` TEXT NULL,
  INDEX (`booking_id`),
  INDEX (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings`(`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Bảng reviews
-- 1 booking -> 0..1 review
-- ----------------------------------------------------------------
CREATE TABLE `reviews` (
  `review_id` INT AUTO_INCREMENT PRIMARY KEY,
  `booking_id` INT NOT NULL,
  `customer_id` INT NULL,
  `rating` TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  `comment` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (`booking_id`),
  INDEX (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings`(`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_customer` FOREIGN KEY (`customer_id`) REFERENCES `users`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Bảng notifications
-- ----------------------------------------------------------------
CREATE TABLE `notifications` (
  `notification_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NULL,
  `restaurant_id` INT NULL,
  `content` TEXT NOT NULL,
  `type` ENUM('booking_reminder','booking_update','promotion','system') NOT NULL DEFAULT 'booking_reminder',
  `sent_at` TIMESTAMP NULL,
  `status` ENUM('pending','sent','failed') NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (`user_id`),
  INDEX (`restaurant_id`),
  INDEX (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Bảng promotions (ưu đãi)
-- ----------------------------------------------------------------
CREATE TABLE `promotions` (
  `promotion_id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `discount_percent` DECIMAL(5,2) NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (`restaurant_id`),
  INDEX (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `promotions`
  ADD CONSTRAINT `fk_promotions_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Option: audit/log table (ghi lại hành động quan trọng)
-- ----------------------------------------------------------------
CREATE TABLE `audit_logs` (
  `log_id` INT AUTO_INCREMENT PRIMARY KEY,
  `actor_user_id` INT NULL,
  `action` VARCHAR(255) NOT NULL,
  `entity` VARCHAR(100) NULL,
  `entity_id` INT NULL,
  `details` JSON NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (`actor_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------------------------------------------
-- Một vài dữ liệu mẫu (tuỳ chọn) - bạn có thể bỏ phần này nếu không cần
-- ----------------------------------------------------------------
INSERT INTO `users` (`username`,`password_hash`,`role`,`name`,`phone`,`email`)
VALUES
  ('owner1','<hashed_password>', 'manager', 'Chủ nhà hàng A', '+84900000001','ownerA@example.com'),
  ('reception1','<hashed_password>','staff','Lễ tân 1','+84900000002','receptionA@example.com'),
  ('cust1','<hashed_password>','customer','Khách Hàng 1','+84900000003','cust1@example.com');

INSERT INTO `restaurants` (`name`,`description`,`address`,`phone`,`created_by`)
VALUES ('Nhà hàng A','Mô tả nhà hàng A','Số 1, đường A', '+84911111111', 1);

INSERT INTO `restaurant_tables` (`restaurant_id`,`table_number`,`capacity`)
VALUES (1, 'A1', 4), (1,'A2', 2), (1,'VIP1', 6);

-- ----------------------------------------------------------------
-- Kết thúc
-- ----------------------------------------------------------------
