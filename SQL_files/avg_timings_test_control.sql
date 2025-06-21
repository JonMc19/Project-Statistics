WITH ordered_steps AS (
    SELECT
        d.client_id,
        d.visit_id,
        d.process_step,
        d.date_time,
        LEAD(d.date_time) OVER (
            PARTITION BY d.visit_id
            ORDER BY d.date_time
        ) AS next_time
    FROM df_cleaned_merged_web_data d
),
step_durations AS (
    SELECT
        o.client_id,
        o.process_step,
        TIMESTAMPDIFF(SECOND, o.date_time, o.next_time) AS time_spent
    FROM ordered_steps o
    WHERE o.next_time IS NOT NULL
),
joined_variants AS (
    SELECT
        s.process_step,
        v.Variation,
        s.time_spent
    FROM step_durations s
    JOIN df_experiment_clients_cleaned v
      ON s.client_id = v.client_id
),
aggregated AS (
    SELECT
        process_step,
        Variation,
        ROUND(AVG(time_spent), 2) AS avg_time_seconds,
        COUNT(*) AS num_actions
    FROM joined_variants
    GROUP BY process_step, Variation
),
faster_group_per_step AS (
    SELECT
        process_step,
        Variation AS faster_group
    FROM aggregated a
    WHERE avg_time_seconds = (
        SELECT MIN(avg_time_seconds)
        FROM aggregated b
        WHERE b.process_step = a.process_step
    )
)
SELECT
    a.*,
    f.faster_group
FROM aggregated a
LEFT JOIN faster_group_per_step f
  ON a.process_step = f.process_step
ORDER BY 
    CASE a.process_step
        WHEN 'start' THEN 1
        WHEN 'step_1' THEN 2
        WHEN 'step_2' THEN 3
        WHEN 'step_3' THEN 4
        WHEN 'confirm' THEN 5
        ELSE 6
    END,
    a.Variation;

