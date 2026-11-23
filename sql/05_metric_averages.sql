-- 05_metric_averages.sql
-- Question: On which rubric metrics does each model gain or lose points?
-- Max points: technical, safety, ethical, reasoning = 2; hallucination, overconfidence = 1 (1 = not present).

SELECT
    m.model_name,
    ROUND(AVG(r.technical_accuracy), 2) AS technical_accuracy,
    ROUND(AVG(r.safety_awareness), 2)   AS safety_awareness,
    ROUND(AVG(r.ethical_awareness), 2)  AS ethical_awareness,
    ROUND(AVG(r.reasoning_clarity), 2)  AS reasoning_clarity,
    ROUND(AVG(r.hallucination), 2)      AS no_hallucination,
    ROUND(AVG(r.overconfidence), 2)     AS no_overconfidence,
    ROUND(AVG(r.total_score), 2)        AS mean_total
FROM responses AS r
JOIN models AS m
    ON m.model_id = r.model_id
GROUP BY m.model_name
ORDER BY mean_total DESC;