-- =========================================================
-- Energy_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `energy_db`;

-- 1. Entity-wise total
SELECT e.meter_id, e.customer_name, SUM(t.bill_amount) AS total_value
FROM meters e JOIN energy_usage t ON e.meter_id=t.meter_id
GROUP BY e.meter_id,e.customer_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT usage_type, AVG(bill_amount) AS avg_value
FROM energy_usage GROUP BY usage_type HAVING AVG(bill_amount) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.meter_id) AS record_count, SUM(t.bill_amount) AS total_value
FROM meters e LEFT JOIN energy_usage t ON e.meter_id=t.meter_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM energy_usage ORDER BY bill_amount DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM meters WHERE customer_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM energy_usage WHERE bill_amount BETWEEN (SELECT MIN(bill_amount) FROM energy_usage)
AND (SELECT MAX(bill_amount) FROM energy_usage);

-- 7. IN analysis
SELECT * FROM energy_usage WHERE usage_type IN ('Peak','OffPeak');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN bill_amount >= 7250 THEN 'High'
WHEN bill_amount >= 4100 THEN 'Medium' ELSE 'Low' END AS value_band
FROM energy_usage;

-- 9. GROUP BY HAVING
SELECT usage_type, SUM(bill_amount) AS total_value
FROM energy_usage GROUP BY usage_type
HAVING SUM(bill_amount) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(bill_amount) total_value FROM energy_usage GROUP BY usage_type) x);

-- 10. Window ranking
SELECT meter_id,usage_type,bill_amount,
DENSE_RANK() OVER(PARTITION BY usage_type ORDER BY bill_amount DESC) AS category_rank
FROM energy_usage;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY meter_id ORDER BY bill_amount DESC) AS rn
FROM energy_usage;

-- 12. LAG comparison
SELECT *, LAG(bill_amount) OVER(PARTITION BY meter_id ORDER BY reading_date) AS previous_value
FROM energy_usage;

-- 13. Running total
SELECT *, SUM(bill_amount) OVER(PARTITION BY meter_id ORDER BY reading_date)
AS running_total
FROM energy_usage;

-- 14. Monthly trend
SELECT DATE_FORMAT(reading_date,'%Y-%m') AS month, SUM(bill_amount) AS total_value
FROM energy_usage GROUP BY DATE_FORMAT(reading_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT usage_type,SUM(bill_amount) total_value FROM energy_usage GROUP BY usage_type)
SELECT usage_type,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM energy_usage t
WHERE bill_amount > (SELECT AVG(t2b.bill_amount) FROM energy_usage t2b WHERE t2b.usage_type=t.usage_type);

-- 17. Entity count
SELECT meter_id, COUNT(*) AS record_count FROM energy_usage
GROUP BY meter_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.bill_amount) total_value
FROM meters e JOIN energy_usage t ON e.meter_id=t.meter_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT usage_type,SUM(bill_amount) total_value FROM energy_usage
GROUP BY usage_type ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT usage_type,COUNT(*) records,SUM(bill_amount) total_value,
AVG(bill_amount) avg_value,MIN(bill_amount) min_value,MAX(bill_amount) max_value,
DENSE_RANK() OVER(ORDER BY SUM(bill_amount) DESC) business_rank
FROM energy_usage GROUP BY usage_type ORDER BY business_rank;

