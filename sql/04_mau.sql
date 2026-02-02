-- Purpose: Monthly Active Users (MAU)

WITH monthly AS (
    SELECT DISTINCT
        user_id,
        DATE_FORMAT(login_date, '%Y-%m-01') AS login_month
    FROM logins
)
SELECT
    login_month,
    COUNT(*) AS mau
FROM monthly
GROUP BY login_month
ORDER BY login_month;
