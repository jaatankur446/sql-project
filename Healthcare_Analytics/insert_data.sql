-- =========================================================
-- Healthcare_Analytics
-- Insert Data File: patients
-- =========================================================
USE `healthcare_db`;

INSERT INTO `patients` VALUES
('P001','Neha Singh','Mumbai','Insurance',21),
('P002','Riya Sharma','Patna','Corporate',22),
('P003','Karan Verma','Kolkata','General',23),
('P004','Pooja Gupta','Pune','Insurance',24),
('P005','Vikas Kumar','Bangalore','Corporate',25),
('P006','Anita Singh','Delhi','General',26),
('P007','Rahul Verma','Mumbai','Insurance',27),
('P008','Amit Kumar','Patna','Corporate',28),
('P009','Neha Singh','Kolkata','General',29),
('P010','Riya Sharma','Pune','Insurance',30),
('P011','Karan Verma','Bangalore','Corporate',31),
('P012','Pooja Gupta','Delhi','General',32),
('P013','Vikas Kumar','Mumbai','Insurance',33),
('P014','Anita Singh','Patna','Corporate',34),
('P015','Rahul Verma','Kolkata','General',35),
('P016','Amit Kumar','Pune','Insurance',36),
('P017','Neha Singh','Bangalore','Corporate',37),
('P018','Riya Sharma','Delhi','General',38),
('P019','Karan Verma','Mumbai','Insurance',39),
('P020','Pooja Gupta','Patna','Corporate',40);

-- =========================================================
-- Healthcare_Analytics
-- Insert Data File: visits
-- =========================================================
USE `healthcare_db`;

INSERT INTO `visits` VALUES
('V001','P001','Orthopedics','2026-02-12',625.00),
('V002','P002','Neurology','2026-03-18',750.00),
('V003','P003','General','2026-04-21',875.00),
('V004','P004','Cardiology','2026-05-09',1000.00),
('V005','P005','Orthopedics','2026-06-15',1125.00),
('V006','P006','Neurology','2026-07-22',1250.00),
('V007','P007','General','2026-08-11',1375.00),
('V008','P008','Cardiology','2026-09-20',1500.00),
('V009','P009','Orthopedics','2026-01-05',1625.00),
('V010','P010','Neurology','2026-02-12',1750.00),
('V011','P011','General','2026-03-18',1875.00),
('V012','P012','Cardiology','2026-04-21',2000.00),
('V013','P013','Orthopedics','2026-05-09',2125.00),
('V014','P014','Neurology','2026-06-15',2250.00),
('V015','P015','General','2026-07-22',2375.00),
('V016','P016','Cardiology','2026-08-11',2500.00),
('V017','P017','Orthopedics','2026-09-20',2625.00),
('V018','P018','Neurology','2026-01-05',2750.00),
('V019','P019','General','2026-02-12',2875.00),
('V020','P020','Cardiology','2026-03-18',3000.00);
