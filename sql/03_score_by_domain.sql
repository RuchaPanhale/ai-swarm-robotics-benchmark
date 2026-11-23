-- 03_score_by_domain.sql
-- Question: How does each model score in each of the 6 domains?

SELECT
    q.domain,
    ROUND(AVG(CASE WHEN r.model_id = 'chatgpt'    THEN r.total_score END), 2) AS "ChatGPT 5.3 Instant",
    ROUND(AVG(CASE WHEN r.model_id = 'claude'     THEN r.total_score END), 2) AS "Claude Sonnet 4.6",
    ROUND(AVG(CASE WHEN r.model_id = 'gemini'     THEN r.total_score END), 2) AS "Gemini 3 Flash",
    ROUND(AVG(CASE WHEN r.model_id = 'perplexity' THEN r.total_score END), 2) AS "Perplexity AI Sonar",
    ROUND(AVG(r.total_score), 2)                                              AS all_models
FROM responses AS r
JOIN questions AS q
    ON q.question_id = r.question_id
GROUP BY q.domain
ORDER BY q.domain;