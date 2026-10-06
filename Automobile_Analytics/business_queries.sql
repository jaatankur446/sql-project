-- =========================================================
-- Automobile_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `automobile_db`;

-- 1. Entity-wise total
SELECT e.vehicle_id, e.vehicle_name, SUM(t.service_cost) AS total_value
FROM vehicles e JOIN service_records t ON e.vehicle_id=t.vehicle_id
GROUP BY e.vehicle_id,e.vehicle_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT service_type, AVG(service_cost) AS avg_value
FROM service_records GROUP BY service_type HAVING AVG(service_cost) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.vehicle_id) AS record_count, SUM(t.service_cost) AS total_value
FROM vehicles e LEFT JOIN service_records t ON e.vehicle_id=t.vehicle_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM service_records ORDER BY service_cost DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM vehicles WHERE vehicle_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM service_records WHERE service_cost BETWEEN (SELECT MIN(service_cost) FROM service_records)
AND (SELECT MAX(service_cost) FROM service_records);

-- 7. IN analysis
SELECT * FROM service_records WHERE service_type IN ('Regular','Repair');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN service_cost >= 3425 THEN 'High'
WHEN service_cost >= 2200 THEN 'Medium' ELSE 'Low' END AS value_band
FROM service_records;

-- 9. GROUP BY HAVING
SELECT service_type, SUM(service_cost) AS total_value
FROM service_records GROUP BY service_type
HAVING SUM(service_cost) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(service_cost) total_value FROM service_records GROUP BY service_type) x);

-- 10. Window ranking
SELECT vehicle_id,service_type,service_cost,
DENSE_RANK() OVER(PARTITION BY service_type ORDER BY service_cost DESC) AS category_rank
FROM service_records;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY vehicle_id ORDER BY service_cost DESC) AS rn
FROM service_records;

-- 12. LAG comparison
SELECT *, LAG(service_cost) OVER(PARTITION BY vehicle_id ORDER BY service_date) AS previous_value
FROM service_records;

-- 13. Running total
SELECT *, SUM(service_cost) OVER(PARTITION BY vehicle_id ORDER BY service_date)
AS running_total
FROM service_records;

-- 14. Monthly trend
SELECT DATE_FORMAT(service_date,'%Y-%m') AS month, SUM(service_cost) AS total_value
FROM service_records GROUP BY DATE_FORMAT(service_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT service_type,SUM(service_cost) total_value FROM service_records GROUP BY service_type)
SELECT service_type,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM service_records t
WHERE service_cost > (SELECT AVG(t2b.service_cost) FROM service_records t2b WHERE t2b.service_type=t.service_type);

-- 17. Entity count
SELECT vehicle_id, COUNT(*) AS record_count FROM service_records
GROUP BY vehicle_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.service_cost) total_value
FROM vehicles e JOIN service_records t ON e.vehicle_id=t.vehicle_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT service_type,SUM(service_cost) total_value FROM service_records
GROUP BY service_type ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT service_type,COUNT(*) records,SUM(service_cost) total_value,
AVG(service_cost) avg_value,MIN(service_cost) min_value,MAX(service_cost) max_value,
DENSE_RANK() OVER(ORDER BY SUM(service_cost) DESC) business_rank
FROM service_records GROUP BY service_type ORDER BY business_rank;

