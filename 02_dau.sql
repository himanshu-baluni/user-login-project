-- Purpose: Daily Active Users (DAU)
-- Grain: One row per day

SELECT
    login_date,
    COUNT(DISTINCT user_id) AS dau
FROM logins
GROUP BY login_date
ORDER BY login_date;
