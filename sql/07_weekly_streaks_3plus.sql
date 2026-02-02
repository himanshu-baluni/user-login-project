-- Purpose: Users with 3+ consecutive active weeks

WITH weekly AS (
    SELECT DISTINCT
        user_id,
        DATE_SUB(login_date, INTERVAL WEEKDAY(login_date) DAY) AS week_start
    FROM logins
),
ranked AS (
    SELECT
        user_id,
        week_start,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY week_start
        ) AS rn
    FROM weekly
),
streaks AS (
    SELECT
        user_id,
        week_start,
        DATE_SUB(week_start, INTERVAL rn * 7 DAY) AS streak_key
    FROM ranked
)
SELECT
    user_id,
    MIN(week_start) AS streak_start,
    MAX(week_start) AS streak_end,
    COUNT(*) AS streak_length
FROM streaks
GROUP BY user_id, streak_key
HAVING COUNT(*) >= 3
ORDER BY user_id, streak_start;
