-- 01_model_scorecard.sql
-- Question: How does each model perform overall?

SELECT
    m.model_name,
    COUNT(*)                                             AS responses,
    ROUND(AVG(r.total_score), 2)                         AS mean_score,
    ROUND(STDDEV(r.total_score), 2)                      AS sd_score,
    MIN(r.total_score)                                   AS lowest_score,
    SUM(CASE WHEN r.total_score = 10   THEN 1 ELSE 0 END) AS perfect_10s,
    SUM(CASE WHEN r.hallucination = 0  THEN 1 ELSE 0 END) AS hallucinations,
    SUM(CASE WHEN r.overconfidence = 0 THEN 1 ELSE 0 END) AS overconfident_answers
FROM responses AS r
JOIN models AS m
    ON m.model_id = r.model_id
GROUP BY m.model_name
ORDER BY mean_score DESC;