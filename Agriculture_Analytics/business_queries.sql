-- =========================================================
-- Agriculture_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `agriculture_db`;

-- 1. Entity-wise total
SELECT e.farm_id, e.farmer_name, SUM(t.revenue) AS total_value
FROM farms e JOIN harvest_records t ON e.farm_id=t.farm_id
GROUP BY e.farm_id,e.farmer_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT crop_type, AVG(revenue) AS avg_value
FROM harvest_records GROUP BY crop_type HAVING AVG(revenue) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.farm_id) AS record_count, SUM(t.revenue) AS total_value
FROM farms e LEFT JOIN harvest_records t ON e.farm_id=t.farm_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM harvest_records ORDER BY revenue DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM farms WHERE farmer_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM harvest_records WHERE revenue BETWEEN (SELECT MIN(revenue) FROM harvest_records)
AND (SELECT MAX(revenue) FROM harvest_records);

-- 7. IN analysis
SELECT * FROM harvest_records WHERE crop_type IN ('Rice','Wheat');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN revenue >= 115000 THEN 'High'
WHEN revenue >= 66000 THEN 'Medium' ELSE 'Low' END AS value_band
FROM harvest_records;

-- 9. GROUP BY HAVING
SELECT crop_type, SUM(revenue) AS total_value
FROM harvest_records GROUP BY crop_type
HAVING SUM(revenue) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(revenue) total_value FROM harvest_records GROUP BY crop_type) x);

-- 10. Window ranking
SELECT farm_id,crop_type,revenue,
DENSE_RANK() OVER(PARTITION BY crop_type ORDER BY revenue DESC) AS category_rank
FROM harvest_records;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY farm_id ORDER BY revenue DESC) AS rn
FROM harvest_records;

-- 12. LAG comparison
SELECT *, LAG(revenue) OVER(PARTITION BY farm_id ORDER BY harvest_date) AS previous_value
FROM harvest_records;

-- 13. Running total
SELECT *, SUM(revenue) OVER(PARTITION BY farm_id ORDER BY harvest_date)
AS running_total
FROM harvest_records;

-- 14. Monthly trend
SELECT DATE_FORMAT(harvest_date,'%Y-%m') AS month, SUM(revenue) AS total_value
FROM harvest_records GROUP BY DATE_FORMAT(harvest_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT crop_type,SUM(revenue) total_value FROM harvest_records GROUP BY crop_type)
SELECT crop_type,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM harvest_records t
WHERE revenue > (SELECT AVG(t2b.revenue) FROM harvest_records t2b WHERE t2b.crop_type=t.crop_type);

-- 17. Entity count
SELECT farm_id, COUNT(*) AS record_count FROM harvest_records
GROUP BY farm_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.revenue) total_value
FROM farms e JOIN harvest_records t ON e.farm_id=t.farm_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT crop_type,SUM(revenue) total_value FROM harvest_records
GROUP BY crop_type ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT crop_type,COUNT(*) records,SUM(revenue) total_value,
AVG(revenue) avg_value,MIN(revenue) min_value,MAX(revenue) max_value,
DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) business_rank
FROM harvest_records GROUP BY crop_type ORDER BY business_rank;

