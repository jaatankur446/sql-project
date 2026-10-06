-- =========================================================
-- Automobile_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `automobile_db`;
USE `automobile_db`;

DROP TABLE IF EXISTS `service_records`;
DROP TABLE IF EXISTS `vehicles`;

CREATE TABLE `vehicles` (
vehicle_id VARCHAR(10) PRIMARY KEY,
vehicle_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
vehicle_type VARCHAR(40) NOT NULL
);

CREATE TABLE `service_records` (
transaction_id VARCHAR(10) PRIMARY KEY,
vehicle_id VARCHAR(10) NOT NULL,
service_type VARCHAR(40) NOT NULL,
service_date DATE NOT NULL,
service_cost DECIMAL(14,2) NOT NULL,
FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);
