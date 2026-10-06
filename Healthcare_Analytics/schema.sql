-- =========================================================
-- Healthcare_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `healthcare_db`;
USE `healthcare_db`;

DROP TABLE IF EXISTS `visits`;
DROP TABLE IF EXISTS `patients`;

CREATE TABLE `patients` (
patient_id VARCHAR(10) PRIMARY KEY,
patient_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
patient_type VARCHAR(30) NOT NULL,
age INT
);

CREATE TABLE `visits` (
visit_id VARCHAR(10) PRIMARY KEY,
patient_id VARCHAR(10) NOT NULL,
department VARCHAR(40) NOT NULL,
visit_date DATE NOT NULL,
treatment_cost DECIMAL(12,2) NOT NULL,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
