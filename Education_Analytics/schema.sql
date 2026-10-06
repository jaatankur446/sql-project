-- =========================================================
-- Education_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `education_db`;
USE `education_db`;

DROP TABLE IF EXISTS `exam_results`;
DROP TABLE IF EXISTS `students`;

CREATE TABLE `students` (
student_id VARCHAR(10) PRIMARY KEY,
student_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
course VARCHAR(40) NOT NULL
);

CREATE TABLE `exam_results` (
transaction_id VARCHAR(10) PRIMARY KEY,
student_id VARCHAR(10) NOT NULL,
subject VARCHAR(40) NOT NULL,
exam_date DATE NOT NULL,
marks DECIMAL(14,2) NOT NULL,
FOREIGN KEY (student_id) REFERENCES students(student_id)
);
