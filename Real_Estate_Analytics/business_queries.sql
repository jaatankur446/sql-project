-- =========================================================
-- Real_Estate_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `realestate_db`;

-- 1. Entity-wise total
SELECT e.property_id, e.property_name, SUM(t.sale_price) AS total_value
FROM properties e JOIN property_sales t ON e.property_id=t.property_id
GROUP BY e.property_id,e.property_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT sale_type, AVG(sale_price) AS avg_value
FROM property_sales GROUP BY sale_type HAVING AVG(sale_price) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.property_id) AS record_count, SUM(t.sale_price) AS total_value
FROM properties e LEFT JOIN property_sales t ON e.property_id=t.property_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM property_sales ORDER BY sale_price DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM properties WHERE property_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM property_sales WHERE sale_price BETWEEN (SELECT MIN(sale_price) FROM property_sales)
AND (SELECT MAX(sale_price) FROM property_sales);

-- 7. IN analysis
SELECT * FROM property_sales WHERE sale_type IN ('New','Resale');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN sale_price >= 4750000 THEN 'High'
WHEN sale_price >= 3000000 THEN 'Medium' ELSE 'Low' END AS value_band
FROM property_sales;

-- 9. GROUP BY HAVING
SELECT sale_type, SUM(sale_price) AS total_value
FROM property_sales GROUP BY sale_type
HAVING SUM(sale_price) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(sale_price) total_value FROM property_sales GROUP BY sale_type) x);

-- 10. Window ranking
SELECT property_id,sale_type,sale_price,
DENSE_RANK() OVER(PARTITION BY sale_type ORDER BY sale_price DESC) AS category_rank
FROM property_sales;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY property_id ORDER BY sale_price DESC) AS rn
FROM property_sales;

-- 12. LAG comparison
SELECT *, LAG(sale_price) OVER(PARTITION BY property_id ORDER BY sale_date) AS previous_value
FROM property_sales;

-- 13. Running total
SELECT *, SUM(sale_price) OVER(PARTITION BY property_id ORDER BY sale_date)
AS running_total
FROM property_sales;

-- 14. Monthly trend
SELECT DATE_FORMAT(sale_date,'%Y-%m') AS month, SUM(sale_price) AS total_value
FROM property_sales GROUP BY DATE_FORMAT(sale_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT sale_type,SUM(sale_price) total_value FROM property_sales GROUP BY sale_type)
SELECT sale_type,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM property_sales t
WHERE sale_price > (SELECT AVG(t2b.sale_price) FROM property_sales t2b WHERE t2b.sale_type=t.sale_type);

-- 17. Entity count
SELECT property_id, COUNT(*) AS record_count FROM property_sales
GROUP BY property_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.sale_price) total_value
FROM properties e JOIN property_sales t ON e.property_id=t.property_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT sale_type,SUM(sale_price) total_value FROM property_sales
GROUP BY sale_type ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT sale_type,COUNT(*) records,SUM(sale_price) total_value,
AVG(sale_price) avg_value,MIN(sale_price) min_value,MAX(sale_price) max_value,
DENSE_RANK() OVER(ORDER BY SUM(sale_price) DESC) business_rank
FROM property_sales GROUP BY sale_type ORDER BY business_rank;

