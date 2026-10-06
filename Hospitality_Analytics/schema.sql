-- =========================================================
-- Hospitality_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `hospitality_db`;
USE `hospitality_db`;

DROP TABLE IF EXISTS `hotel_bookings`;
DROP TABLE IF EXISTS `hotels`;

CREATE TABLE `hotels` (
hotel_id VARCHAR(10) PRIMARY KEY,
hotel_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
hotel_type VARCHAR(40) NOT NULL
);

CREATE TABLE `hotel_bookings` (
transaction_id VARCHAR(10) PRIMARY KEY,
hotel_id VARCHAR(10) NOT NULL,
room_type VARCHAR(40) NOT NULL,
booking_date DATE NOT NULL,
room_charge DECIMAL(14,2) NOT NULL,
FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);
