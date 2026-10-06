-- =========================================================
-- Cinema_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `cinema_db`;

-- 1. Entity-wise total
SELECT e.movie_id, e.movie_name, SUM(t.box_office) AS total_value
FROM movies e JOIN ticket_sales t ON e.movie_id=t.movie_id
GROUP BY e.movie_id,e.movie_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT city, AVG(box_office) AS avg_value
FROM ticket_sales GROUP BY city HAVING AVG(box_office) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.movie_id) AS record_count, SUM(t.box_office) AS total_value
FROM movies e LEFT JOIN ticket_sales t ON e.movie_id=t.movie_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM ticket_sales ORDER BY box_office DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM movies WHERE movie_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM ticket_sales WHERE box_office BETWEEN (SELECT MIN(box_office) FROM ticket_sales)
AND (SELECT MAX(box_office) FROM ticket_sales);

-- 7. IN analysis
SELECT * FROM ticket_sales WHERE city IN ('Delhi','Mumbai');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN box_office >= 181000 THEN 'High'
WHEN box_office >= 97000 THEN 'Medium' ELSE 'Low' END AS value_band
FROM ticket_sales;

-- 9. GROUP BY HAVING
SELECT city, SUM(box_office) AS total_value
FROM ticket_sales GROUP BY city
HAVING SUM(box_office) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(box_office) total_value FROM ticket_sales GROUP BY city) x);

-- 10. Window ranking
SELECT movie_id,city,box_office,
DENSE_RANK() OVER(PARTITION BY city ORDER BY box_office DESC) AS category_rank
FROM ticket_sales;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY movie_id ORDER BY box_office DESC) AS rn
FROM ticket_sales;

-- 12. LAG comparison
SELECT *, LAG(box_office) OVER(PARTITION BY movie_id ORDER BY show_date) AS previous_value
FROM ticket_sales;

-- 13. Running total
SELECT *, SUM(box_office) OVER(PARTITION BY movie_id ORDER BY show_date)
AS running_total
FROM ticket_sales;

-- 14. Monthly trend
SELECT DATE_FORMAT(show_date,'%Y-%m') AS month, SUM(box_office) AS total_value
FROM ticket_sales GROUP BY DATE_FORMAT(show_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT city,SUM(box_office) total_value FROM ticket_sales GROUP BY city)
SELECT city,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM ticket_sales t
WHERE box_office > (SELECT AVG(t2b.box_office) FROM ticket_sales t2b WHERE t2b.city=t.city);

-- 17. Entity count
SELECT movie_id, COUNT(*) AS record_count FROM ticket_sales
GROUP BY movie_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.box_office) total_value
FROM movies e JOIN ticket_sales t ON e.movie_id=t.movie_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT city,SUM(box_office) total_value FROM ticket_sales
GROUP BY city ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT city,COUNT(*) records,SUM(box_office) total_value,
AVG(box_office) avg_value,MIN(box_office) min_value,MAX(box_office) max_value,
DENSE_RANK() OVER(ORDER BY SUM(box_office) DESC) business_rank
FROM ticket_sales GROUP BY city ORDER BY business_rank;

