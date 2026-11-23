-- export_judge_detail.sql
-- One row per judged answer (108 rows): human vs AI judge (DeepSeek V4 Pro), for Tableau.
-- gap = judge score minus human score (negative = the judge scored lower)

SELECT
    m.model_name,
    j.question_id,
    q.domain,
    q.question_type,
    j.human_score,
    j.judge_score,
    j.judge_score - j.human_score AS gap
FROM judge_scores AS j
JOIN questions AS q
    ON q.question_id = j.question_id
JOIN models AS m
    ON m.model_id = j.model_id
ORDER BY m.model_name, j.question_id;