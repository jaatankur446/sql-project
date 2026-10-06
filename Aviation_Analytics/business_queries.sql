-- =========================================================
-- Aviation_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `aviation_db`;

-- 1. Entity-wise total
SELECT e.flight_id, e.flight_name, SUM(t.fare) AS total_value
FROM flights e JOIN bookings t ON e.flight_id=t.flight_id
GROUP BY e.flight_id,e.flight_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT travel_class, AVG(fare) AS avg_value
FROM bookings GROUP BY travel_class HAVING AVG(fare) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.flight_id) AS record_count, SUM(t.fare) AS total_value
FROM flights e LEFT JOIN bookings t ON e.flight_id=t.flight_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM bookings ORDER BY fare DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM flights WHERE flight_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM bookings WHERE fare BETWEEN (SELECT MIN(fare) FROM bookings)
AND (SELECT MAX(fare) FROM bookings);

-- 7. IN analysis
SELECT * FROM bookings WHERE travel_class IN ('Economy','Premium');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN fare >= 30000 THEN 'High'
WHEN fare >= 17400 THEN 'Medium' ELSE 'Low' END AS value_band
FROM bookings;

-- 9. GROUP BY HAVING
SELECT travel_class, SUM(fare) AS total_value
FROM bookings GROUP BY travel_class
HAVING SUM(fare) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(fare) total_value FROM bookings GROUP BY travel_class) x);

-- 10. Window ranking
SELECT flight_id,travel_class,fare,
DENSE_RANK() OVER(PARTITION BY travel_class ORDER BY fare DESC) AS category_rank
FROM bookings;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY flight_id ORDER BY fare DESC) AS rn
FROM bookings;

-- 12. LAG comparison
SELECT *, LAG(fare) OVER(PARTITION BY flight_id ORDER BY booking_date) AS previous_value
FROM bookings;

-- 13. Running total
SELECT *, SUM(fare) OVER(PARTITION BY flight_id ORDER BY booking_date)
AS running_total
FROM bookings;

-- 14. Monthly trend
SELECT DATE_FORMAT(booking_date,'%Y-%m') AS month, SUM(fare) AS total_value
FROM bookings GROUP BY DATE_FORMAT(booking_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT travel_class,SUM(fare) total_value FROM bookings GROUP BY travel_class)
SELECT travel_class,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM bookings t
WHERE fare > (SELECT AVG(t2b.fare) FROM bookings t2b WHERE t2b.travel_class=t.travel_class);

-- 17. Entity count
SELECT flight_id, COUNT(*) AS record_count FROM bookings
GROUP BY flight_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.fare) total_value
FROM flights e JOIN bookings t ON e.flight_id=t.flight_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT travel_class,SUM(fare) total_value FROM bookings
GROUP BY travel_class ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT travel_class,COUNT(*) records,SUM(fare) total_value,
AVG(fare) avg_value,MIN(fare) min_value,MAX(fare) max_value,
DENSE_RANK() OVER(ORDER BY SUM(fare) DESC) business_rank
FROM bookings GROUP BY travel_class ORDER BY business_rank;

