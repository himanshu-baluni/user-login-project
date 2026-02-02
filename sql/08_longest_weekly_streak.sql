-- Purpose: Longest weekly login streak per user

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
streak_groups AS (
    SELECT
        user_id,
        week_start,
        DATE_SUB(week_start, INTERVAL rn * 7 DAY) AS streak_key
    FROM ranked
),
streak_lengths AS (
    SELECT
        user_id,
        streak_key,
        COUNT(*) AS streak_length
    FROM streak_groups
    GROUP BY user_id, streak_key
)
SELECT
    user_id,
    MAX(streak_length) AS longest_weekly_streak
FROM streak_lengths
GROUP BY user_id
ORDER BY longest_weekly_streak DESC;
