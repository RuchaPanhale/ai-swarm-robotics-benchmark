-- export_responses_detail.sql
-- One row per answer (216 rows) with model, domain and question type, for Tableau filters.

SELECT
    m.model_name,
    r.question_id,
    q.scenario_id,
    q.domain,
    q.question_type,
    r.technical_accuracy,
    r.safety_awareness,
    r.ethical_awareness,
    r.reasoning_clarity,
    r.hallucination,
    r.overconfidence,
    r.total_score
FROM responses AS r
JOIN questions AS q
    ON q.question_id = r.question_id
JOIN models AS m
    ON m.model_id = r.model_id
ORDER BY m.model_name, r.question_id;