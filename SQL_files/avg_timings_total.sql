use Project_Statistics;

WITH ordered_steps AS (
    SELECT
        *,
        LEAD(date_time) OVER (
            PARTITION BY visit_id
            ORDER BY date_time
        ) AS next_time
    FROM df_cleaned_merged_web_data
),
step_durations AS (
    SELECT
        process_step,
        TIMESTAMPDIFF(SECOND, date_time, next_time) AS time_spent
    FROM ordered_steps
    WHERE next_time IS NOT NULL
)
SELECT
    process_step,
    ROUND(AVG(time_spent), 2) AS avg_time_seconds
FROM step_durations
GROUP BY process_step
ORDER BY
    CASE process_step
        WHEN 'start' THEN 1
        WHEN 'step_1' THEN 2
        WHEN 'step_2' THEN 3
        WHEN 'step_3' THEN 4
        WHEN 'confirm' THEN 5
        ELSE 6
    END;


