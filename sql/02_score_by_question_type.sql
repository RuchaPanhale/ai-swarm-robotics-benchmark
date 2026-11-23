-- 02_score_by_question_type.sql
-- Question: How does each model score on Technical, Safety and Ethical questions?

SELECT
    q.question_type,
    m.model_name,
    COUNT(*)                     AS responses,
    ROUND(AVG(r.total_score), 2) AS mean_score
FROM responses AS r
JOIN questions AS q
    ON q.question_id = r.question_id
JOIN models AS m
    ON m.model_id = r.model_id
GROUP BY q.question_type, m.model_name
ORDER BY q.question_type, mean_score DESC;