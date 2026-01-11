-- Purpose: Weekly retention
-- Definition: users active in consecutive weeks

WITH weekly AS (
    SELECT DISTINCT
        user_id,
        DATE_SUB(login_date, INTERVAL WEEKDAY(login_date) DAY) AS week
    FROM logins
),
w_next AS (
    SELECT
        user_id,
        week,
        LEAD(week) OVER (
            PARTITION BY user_id
            ORDER BY week
        ) AS next_week
    FROM weekly
)
SELECT
    week,
    COUNT(DISTINCT user_id) AS retained_users
FROM w_next
WHERE next_week = DATE_ADD(week, INTERVAL 7 DAY)
GROUP BY week
ORDER BY week;
