-- 04_hallucinations_by_domain.sql
-- Question: Which models hallucinated, and in which domains?
-- Reminder: hallucination = 0 means a hallucination WAS present.

SELECT
    m.model_name,
    q.domain,
    COUNT(*) AS hallucinations
FROM responses AS r
JOIN questions AS q
    ON q.question_id = r.question_id
JOIN models AS m
    ON m.model_id = r.model_id
WHERE r.hallucination = 0
GROUP BY m.model_name, q.domain
ORDER BY hallucinations DESC, m.model_name, q.domain;