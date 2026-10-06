-- =========================================================
-- Cinema_Analytics
-- MySQL Schema File
-- =========================================================
CREATE DATABASE IF NOT EXISTS `cinema_db`;
USE `cinema_db`;

DROP TABLE IF EXISTS `ticket_sales`;
DROP TABLE IF EXISTS `movies`;

CREATE TABLE `movies` (
movie_id VARCHAR(10) PRIMARY KEY,
movie_name VARCHAR(80) NOT NULL,
city VARCHAR(40) NOT NULL,
genre VARCHAR(40) NOT NULL
);

CREATE TABLE `ticket_sales` (
transaction_id VARCHAR(10) PRIMARY KEY,
movie_id VARCHAR(10) NOT NULL,
city VARCHAR(40) NOT NULL,
show_date DATE NOT NULL,
box_office DECIMAL(14,2) NOT NULL,
FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);
