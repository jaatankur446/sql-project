-- =========================================================
-- Pharma_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `pharma_db`;
USE `pharma_db`;

DROP TABLE IF EXISTS `drug_orders`;
DROP TABLE IF EXISTS `medicines`;

CREATE TABLE `medicines` (
medicine_id VARCHAR(10) PRIMARY KEY,
medicine_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
category VARCHAR(40) NOT NULL
);

CREATE TABLE `drug_orders` (
transaction_id VARCHAR(10) PRIMARY KEY,
medicine_id VARCHAR(10) NOT NULL,
hospital VARCHAR(40) NOT NULL,
order_date DATE NOT NULL,
order_value DECIMAL(14,2) NOT NULL,
FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);
