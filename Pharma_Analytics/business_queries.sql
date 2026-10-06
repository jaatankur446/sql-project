-- =========================================================
-- Pharma_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `pharma_db`;

-- 1. Entity-wise total
SELECT e.medicine_id, e.medicine_name, SUM(t.order_value) AS total_value
FROM medicines e JOIN drug_orders t ON e.medicine_id=t.medicine_id
GROUP BY e.medicine_id,e.medicine_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT hospital, AVG(order_value) AS avg_value
FROM drug_orders GROUP BY hospital HAVING AVG(order_value) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.medicine_id) AS record_count, SUM(t.order_value) AS total_value
FROM medicines e LEFT JOIN drug_orders t ON e.medicine_id=t.medicine_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM drug_orders ORDER BY order_value DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM medicines WHERE medicine_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM drug_orders WHERE order_value BETWEEN (SELECT MIN(order_value) FROM drug_orders)
AND (SELECT MAX(order_value) FROM drug_orders);

-- 7. IN analysis
SELECT * FROM drug_orders WHERE hospital IN ('AIIMS','City Hospital');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN order_value >= 140000 THEN 'High'
WHEN order_value >= 77000 THEN 'Medium' ELSE 'Low' END AS value_band
FROM drug_orders;

-- 9. GROUP BY HAVING
SELECT hospital, SUM(order_value) AS total_value
FROM drug_orders GROUP BY hospital
HAVING SUM(order_value) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(order_value) total_value FROM drug_orders GROUP BY hospital) x);

-- 10. Window ranking
SELECT medicine_id,hospital,order_value,
DENSE_RANK() OVER(PARTITION BY hospital ORDER BY order_value DESC) AS category_rank
FROM drug_orders;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY medicine_id ORDER BY order_value DESC) AS rn
FROM drug_orders;

-- 12. LAG comparison
SELECT *, LAG(order_value) OVER(PARTITION BY medicine_id ORDER BY order_date) AS previous_value
FROM drug_orders;

-- 13. Running total
SELECT *, SUM(order_value) OVER(PARTITION BY medicine_id ORDER BY order_date)
AS running_total
FROM drug_orders;

-- 14. Monthly trend
SELECT DATE_FORMAT(order_date,'%Y-%m') AS month, SUM(order_value) AS total_value
FROM drug_orders GROUP BY DATE_FORMAT(order_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT hospital,SUM(order_value) total_value FROM drug_orders GROUP BY hospital)
SELECT hospital,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM drug_orders t
WHERE order_value > (SELECT AVG(t2b.order_value) FROM drug_orders t2b WHERE t2b.hospital=t.hospital);

-- 17. Entity count
SELECT medicine_id, COUNT(*) AS record_count FROM drug_orders
GROUP BY medicine_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.order_value) total_value
FROM medicines e JOIN drug_orders t ON e.medicine_id=t.medicine_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT hospital,SUM(order_value) total_value FROM drug_orders
GROUP BY hospital ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT hospital,COUNT(*) records,SUM(order_value) total_value,
AVG(order_value) avg_value,MIN(order_value) min_value,MAX(order_value) max_value,
DENSE_RANK() OVER(ORDER BY SUM(order_value) DESC) business_rank
FROM drug_orders GROUP BY hospital ORDER BY business_rank;

