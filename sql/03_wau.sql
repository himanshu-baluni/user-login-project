-- Purpose: Weekly Active Users (WAU)
-- Week starts on Monday

WITH weekly AS (
    SELECT DISTINCT
        user_id,
        DATE_SUB(login_date, INTERVAL WEEKDAY(login_date) DAY) AS login_week
    FROM logins
)
SELECT
    login_week,
    COUNT(*) AS wau
FROM weekly
GROUP BY login_week
ORDER BY login_week;
