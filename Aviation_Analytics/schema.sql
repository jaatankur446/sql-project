-- =========================================================
-- Aviation_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `aviation_db`;
USE `aviation_db`;

DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `flights`;

CREATE TABLE `flights` (
flight_id VARCHAR(10) PRIMARY KEY,
flight_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
airline VARCHAR(40) NOT NULL
);

CREATE TABLE `bookings` (
transaction_id VARCHAR(10) PRIMARY KEY,
flight_id VARCHAR(10) NOT NULL,
travel_class VARCHAR(40) NOT NULL,
booking_date DATE NOT NULL,
fare DECIMAL(14,2) NOT NULL,
FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);
