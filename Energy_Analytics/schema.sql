-- =========================================================
-- Energy_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `energy_db`;
USE `energy_db`;

DROP TABLE IF EXISTS `energy_usage`;
DROP TABLE IF EXISTS `meters`;

CREATE TABLE `meters` (
meter_id VARCHAR(10) PRIMARY KEY,
customer_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
customer_type VARCHAR(40) NOT NULL
);

CREATE TABLE `energy_usage` (
transaction_id VARCHAR(10) PRIMARY KEY,
meter_id VARCHAR(10) NOT NULL,
usage_type VARCHAR(40) NOT NULL,
reading_date DATE NOT NULL,
bill_amount DECIMAL(14,2) NOT NULL,
FOREIGN KEY (meter_id) REFERENCES meters(meter_id)
);
