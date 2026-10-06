-- =========================================================
-- Education_Analytics
-- Business SQL Analysis
-- Run schema.sql first, then insert_data.sql, then this file.
-- =========================================================
USE `education_db`;

-- 1. Entity-wise total
SELECT e.student_id, e.student_name, SUM(t.marks) AS total_value
FROM students e JOIN exam_results t ON e.student_id=t.student_id
GROUP BY e.student_id,e.student_name ORDER BY total_value DESC;

-- 2. Category-wise average
SELECT subject, AVG(marks) AS avg_value
FROM exam_results GROUP BY subject HAVING AVG(marks) > 0 ORDER BY avg_value DESC;

-- 3. City/category summary
SELECT e.city, COUNT(t.student_id) AS record_count, SUM(t.marks) AS total_value
FROM students e LEFT JOIN exam_results t ON e.student_id=t.student_id
GROUP BY e.city ORDER BY total_value DESC;

-- 4. Top 5 values
SELECT * FROM exam_results ORDER BY marks DESC LIMIT 5;

-- 5. LIKE analysis
SELECT * FROM students WHERE student_name LIKE '%a%';

-- 6. BETWEEN analysis
SELECT * FROM exam_results WHERE marks BETWEEN (SELECT MIN(marks) FROM exam_results)
AND (SELECT MAX(marks) FROM exam_results);

-- 7. IN analysis
SELECT * FROM exam_results WHERE subject IN ('Python','SQL');

-- 8. CASE WHEN segmentation
SELECT *, CASE WHEN marks >= 80 THEN 'High'
WHEN marks >= 59 THEN 'Medium' ELSE 'Low' END AS value_band
FROM exam_results;

-- 9. GROUP BY HAVING
SELECT subject, SUM(marks) AS total_value
FROM exam_results GROUP BY subject
HAVING SUM(marks) > (SELECT AVG(x.total_value) FROM
(SELECT SUM(marks) total_value FROM exam_results GROUP BY subject) x);

-- 10. Window ranking
SELECT student_id,subject,marks,
DENSE_RANK() OVER(PARTITION BY subject ORDER BY marks DESC) AS category_rank
FROM exam_results;

-- 11. ROW_NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY student_id ORDER BY marks DESC) AS rn
FROM exam_results;

-- 12. LAG comparison
SELECT *, LAG(marks) OVER(PARTITION BY student_id ORDER BY exam_date) AS previous_value
FROM exam_results;

-- 13. Running total
SELECT *, SUM(marks) OVER(PARTITION BY student_id ORDER BY exam_date)
AS running_total
FROM exam_results;

-- 14. Monthly trend
SELECT DATE_FORMAT(exam_date,'%Y-%m') AS month, SUM(marks) AS total_value
FROM exam_results GROUP BY DATE_FORMAT(exam_date,'%Y-%m') ORDER BY month;

-- 15. CTE contribution
WITH c AS (SELECT subject,SUM(marks) total_value FROM exam_results GROUP BY subject)
SELECT subject,total_value,ROUND(total_value*100/(SELECT SUM(total_value) FROM c),2) contribution_pct
FROM c ORDER BY total_value DESC;

-- 16. Correlated business filter
SELECT * FROM exam_results t
WHERE marks > (SELECT AVG(t2b.marks) FROM exam_results t2b WHERE t2b.subject=t.subject);

-- 17. Entity count
SELECT student_id, COUNT(*) AS record_count FROM exam_results
GROUP BY student_id ORDER BY record_count DESC;

-- 18. City total
SELECT e.city,SUM(t.marks) total_value
FROM students e JOIN exam_results t ON e.student_id=t.student_id
GROUP BY e.city ORDER BY total_value DESC;

-- 19. Highest category
SELECT subject,SUM(marks) total_value FROM exam_results
GROUP BY subject ORDER BY total_value DESC LIMIT 1;

-- 20. Final KPI report
SELECT subject,COUNT(*) records,SUM(marks) total_value,
AVG(marks) avg_value,MIN(marks) min_value,MAX(marks) max_value,
DENSE_RANK() OVER(ORDER BY SUM(marks) DESC) business_rank
FROM exam_results GROUP BY subject ORDER BY business_rank;

