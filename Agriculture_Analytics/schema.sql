-- =========================================================
-- Agriculture_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `agriculture_db`;
USE `agriculture_db`;

DROP TABLE IF EXISTS `harvest_records`;
DROP TABLE IF EXISTS `farms`;

CREATE TABLE `farms` (
farm_id VARCHAR(10) PRIMARY KEY,
farmer_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
farm_type VARCHAR(40) NOT NULL
);

CREATE TABLE `harvest_records` (
transaction_id VARCHAR(10) PRIMARY KEY,
farm_id VARCHAR(10) NOT NULL,
crop_type VARCHAR(40) NOT NULL,
harvest_date DATE NOT NULL,
revenue DECIMAL(14,2) NOT NULL,
FOREIGN KEY (farm_id) REFERENCES farms(farm_id)
);
