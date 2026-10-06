-- =========================================================
-- Hospitality_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `hospitality_db`;

-- 1. Entity-wise total
SELECT e.hotel_id, e.hotel_name, SUM(t.room_charge) AS total_value
FROM hotels e JOIN hotel_bookings t ON e.hotel_id=t.hotel_id
GROUP BY e.hotel_id,e.hotel_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT room_type, AVG(room_charge) AS avg_value
FROM hotel_bookings GROUP BY room_type HAVING AVG(room_charge) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.hotel_id) AS record_count, SUM(t.room_charge) AS total_value
FROM hotels e LEFT JOIN hotel_bookings t ON e.hotel_id=t.hotel_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM hotel_bookings ORDER BY room_charge DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM hotels WHERE hotel_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM hotel_bookings WHERE room_charge BETWEEN (SELECT MIN(room_charge) FROM hotel_bookings)
AND (SELECT MAX(room_charge) FROM hotel_bookings);

-- 7. IN analysis
SELECT * FROM hotel_bookings WHERE room_type IN ('Standard','Deluxe');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN room_charge >= 11750 THEN 'High'
WHEN room_charge >= 7200 THEN 'Medium' ELSE 'Low' END AS value_band
FROM hotel_bookings;

-- 9. GROUP BY HAVING
SELECT room_type, SUM(room_charge) AS total_value
FROM hotel_bookings GROUP BY room_type
HAVING SUM(room_charge) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(room_charge) total_value FROM hotel_bookings GROUP BY room_type) x);

-- 10. Window ranking
SELECT hotel_id,room_type,room_charge,
DENSE_RANK() OVER(PARTITION BY room_type ORDER BY room_charge DESC) AS category_rank
FROM hotel_bookings;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY hotel_id ORDER BY room_charge DESC) AS rn
FROM hotel_bookings;

-- 12. LAG comparison
SELECT *, LAG(room_charge) OVER(PARTITION BY hotel_id ORDER BY booking_date) AS previous_value
FROM hotel_bookings;

-- 13. Running total
SELECT *, SUM(room_charge) OVER(PARTITION BY hotel_id ORDER BY booking_date)
AS running_total
FROM hotel_bookings;

-- 14. Monthly trend
SELECT DATE_FORMAT(booking_date,'%Y-%m') AS month, SUM(room_charge) AS total_value
FROM hotel_bookings GROUP BY DATE_FORMAT(booking_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT room_type,SUM(room_charge) total_value FROM hotel_bookings GROUP BY room_type)
SELECT room_type,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM hotel_bookings t
WHERE room_charge > (SELECT AVG(t2b.room_charge) FROM hotel_bookings t2b WHERE t2b.room_type=t.room_type);

-- 17. Entity count
SELECT hotel_id, COUNT(*) AS record_count FROM hotel_bookings
GROUP BY hotel_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.room_charge) total_value
FROM hotels e JOIN hotel_bookings t ON e.hotel_id=t.hotel_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT room_type,SUM(room_charge) total_value FROM hotel_bookings
GROUP BY room_type ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT room_type,COUNT(*) records,SUM(room_charge) total_value,
AVG(room_charge) avg_value,MIN(room_charge) min_value,MAX(room_charge) max_value,
DENSE_RANK() OVER(ORDER BY SUM(room_charge) DESC) business_rank
FROM hotel_bookings GROUP BY room_type ORDER BY business_rank;

