-- Purpose: Stickiness ratio (WAU / MAU)
-- Computed at weekly level

WITH weekly AS (
    SELECT DISTINCT
        user_id,
        DATE_SUB(login_date, INTERVAL WEEKDAY(login_date) DAY) AS week
    FROM logins
),
monthly AS (
    SELECT DISTINCT
        user_id,
        DATE_FORMAT(login_date, '%Y-%m-01') AS month
    FROM logins
)
SELECT
    w.week,
    COUNT(DISTINCT w.user_id) / COUNT(DISTINCT m.user_id) AS wau_mau_ratio
FROM weekly w
JOIN monthly m
    ON DATE_FORMAT(w.week, '%Y-%m-01') = m.month
GROUP BY w.week
ORDER BY w.week;
