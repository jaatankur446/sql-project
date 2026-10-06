-- =========================================================
-- Healthcare_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `healthcare_db`;

-- 1. Patient-wise total treatment cost
SELECT p.patient_id, p.patient_name, SUM(v.treatment_cost) AS total_cost
FROM patients p JOIN visits v ON p.patient_id=v.patient_id
GROUP BY p.patient_id,p.patient_name ORDER BY total_cost DESC;

-- 2. Department-wise average cost
SELECT department, AVG(treatment_cost) AS avg_cost
FROM visits GROUP BY department HAVING AVG(treatment_cost)>1000 ORDER BY avg_cost DESC;

-- 3. City-wise visits
SELECT p.city, COUNT(v.visit_id) AS total_visits
FROM patients p LEFT JOIN visits v ON p.patient_id=v.patient_id
GROUP BY p.city ORDER BY total_visits DESC;

-- 4. Top 5 treatment costs
SELECT * FROM visits ORDER BY treatment_cost DESC LIMIT 5;

-- 5. Patients whose names contain 'a'
SELECT * FROM patients WHERE patient_name LIKE '%a%';

-- 6. Visits between selected dates
SELECT * FROM visits WHERE visit_date BETWEEN '2026-03-01' AND '2026-08-31';

-- 7. CASE classification
SELECT visit_id,treatment_cost,
CASE WHEN treatment_cost>=2500 THEN 'High'
     WHEN treatment_cost>=1500 THEN 'Medium' ELSE 'Low' END AS cost_band
FROM visits;

-- 8. Department ranking
SELECT department, SUM(treatment_cost) total_cost,
DENSE_RANK() OVER(ORDER BY SUM(treatment_cost) DESC) AS dept_rank
FROM visits GROUP BY department;

-- 9. Patient transaction row number
SELECT *, ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY treatment_cost DESC) AS rn
FROM visits;

-- 10. Monthly cost
SELECT DATE_FORMAT(visit_date,'%Y-%m') AS month, SUM(treatment_cost) total_cost
FROM visits GROUP BY DATE_FORMAT(visit_date,'%Y-%m') ORDER BY month;



-- 11. ROW_NUMBER by patient
SELECT *, ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY treatment_cost DESC) AS rn
FROM visits;

-- 12. LAG treatment-cost comparison
SELECT *, LAG(treatment_cost) OVER(PARTITION BY patient_id ORDER BY visit_date) AS previous_cost
FROM visits;

-- 13. Running treatment cost
SELECT *, SUM(treatment_cost) OVER(PARTITION BY patient_id ORDER BY visit_date) AS running_cost
FROM visits;

-- 14. Monthly treatment cost
SELECT DATE_FORMAT(visit_date,'%Y-%m') AS month, SUM(treatment_cost) AS total_cost
FROM visits GROUP BY DATE_FORMAT(visit_date,'%Y-%m') ORDER BY month;

-- 15. CTE department contribution
WITH d AS (
    SELECT department, SUM(treatment_cost) AS total_cost
    FROM visits GROUP BY department
)
SELECT department, total_cost,
ROUND(total_cost*100/(SELECT SUM(total_cost) FROM d),2) AS contribution_pct
FROM d ORDER BY total_cost DESC;

-- 16. Above-department-average visits
SELECT v.*
FROM visits v
WHERE v.treatment_cost > (
    SELECT AVG(v2.treatment_cost)
    FROM visits v2
    WHERE v2.department=v.department
);

-- 17. Patient visit count
SELECT patient_id, COUNT(*) AS visit_count
FROM visits GROUP BY patient_id ORDER BY visit_count DESC;

-- 18. City-wise treatment cost
SELECT p.city, SUM(v.treatment_cost) AS total_cost
FROM patients p JOIN visits v ON p.patient_id=v.patient_id
GROUP BY p.city ORDER BY total_cost DESC;

-- 19. Highest-cost department
SELECT department, SUM(treatment_cost) AS total_cost
FROM visits GROUP BY department ORDER BY total_cost DESC LIMIT 1;

-- 20. Final healthcare KPI report
SELECT department,
       COUNT(*) AS visits,
       SUM(treatment_cost) AS total_cost,
       AVG(treatment_cost) AS average_cost,
       MIN(treatment_cost) AS minimum_cost,
       MAX(treatment_cost) AS maximum_cost,
       DENSE_RANK() OVER(ORDER BY SUM(treatment_cost) DESC) AS department_rank
FROM visits
GROUP BY department
ORDER BY department_rank;
