-- =========================================================
-- Energy_Analytics
-- Insert Data File: meters
-- =========================================================
USE `energy_db`;

INSERT INTO `meters` VALUES
('meter001','Neha Singh','Mumbai','Commercial'),
('meter002','Riya Sharma','Patna','Industrial'),
('meter003','Karan Verma','Kolkata','Residential'),
('meter004','Pooja Gupta','Pune','Commercial'),
('meter005','Vikas Kumar','Bangalore','Industrial'),
('meter006','Anita Singh','Delhi','Residential'),
('meter007','Rahul Verma','Mumbai','Commercial'),
('meter008','Amit Kumar','Patna','Industrial'),
('meter009','Neha Singh','Kolkata','Residential'),
('meter010','Riya Sharma','Pune','Commercial'),
('meter011','Karan Verma','Bangalore','Industrial'),
('meter012','Pooja Gupta','Delhi','Residential'),
('meter013','Vikas Kumar','Mumbai','Commercial'),
('meter014','Anita Singh','Patna','Industrial'),
('meter015','Rahul Verma','Kolkata','Residential'),
('meter016','Amit Kumar','Pune','Commercial'),
('meter017','Neha Singh','Bangalore','Industrial'),
('meter018','Riya Sharma','Delhi','Residential'),
('meter019','Karan Verma','Mumbai','Commercial'),
('meter020','Pooja Gupta','Patna','Industrial');

-- =========================================================
-- Energy_Analytics
-- Insert Data File: energy_usage
-- =========================================================
USE `energy_db`;

INSERT INTO `energy_usage` VALUES
('TX001','meter001','OffPeak','2026-02-12',950.00),
('TX002','meter002','Normal','2026-03-18',1400.00),
('TX003','meter003','Peak','2026-04-21',1850.00),
('TX004','meter004','OffPeak','2026-05-09',2300.00),
('TX005','meter005','Normal','2026-06-15',2750.00),
('TX006','meter006','Peak','2026-07-22',3200.00),
('TX007','meter007','OffPeak','2026-08-11',3650.00),
('TX008','meter008','Normal','2026-09-20',4100.00),
('TX009','meter009','Peak','2026-01-05',4550.00),
('TX010','meter010','OffPeak','2026-02-12',5000.00),
('TX011','meter011','Normal','2026-03-18',5450.00),
('TX012','meter012','Peak','2026-04-21',5900.00),
('TX013','meter013','OffPeak','2026-05-09',6350.00),
('TX014','meter014','Normal','2026-06-15',6800.00),
('TX015','meter015','Peak','2026-07-22',7250.00),
('TX016','meter016','OffPeak','2026-08-11',7700.00),
('TX017','meter017','Normal','2026-09-20',8150.00),
('TX018','meter018','Peak','2026-01-05',8600.00),
('TX019','meter019','OffPeak','2026-02-12',9050.00),
('TX020','meter020','Normal','2026-03-18',9500.00);
