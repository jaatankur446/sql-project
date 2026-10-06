-- =========================================================
-- Real_Estate_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `realestate_db`;
USE `realestate_db`;

DROP TABLE IF EXISTS `property_sales`;
DROP TABLE IF EXISTS `properties`;

CREATE TABLE `properties` (
property_id VARCHAR(10) PRIMARY KEY,
property_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
property_type VARCHAR(40) NOT NULL
);

CREATE TABLE `property_sales` (
transaction_id VARCHAR(10) PRIMARY KEY,
property_id VARCHAR(10) NOT NULL,
sale_type VARCHAR(40) NOT NULL,
sale_date DATE NOT NULL,
sale_price DECIMAL(14,2) NOT NULL,
FOREIGN KEY (property_id) REFERENCES properties(property_id)
);
