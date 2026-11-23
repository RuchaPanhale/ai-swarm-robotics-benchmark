-- 06_human_vs_ai_judge.sql
-- Question: How do the AI judge's (DeepSeek V4 Pro) scores compare with human scores?
-- gap = judge score minus human score (negative = the judge scored lower)

-- Part 1: one row per model
SELECT
    m.model_name,
    COUNT(*)                                                AS answers,
    ROUND(AVG(j.human_score), 2)                            AS human_mean,
    ROUND(AVG(j.judge_score), 2)                            AS judge_mean,
    ROUND(AVG(j.judge_score - j.human_score), 2)            AS mean_gap,
    SUM(CASE WHEN j.judge_score < j.human_score THEN 1 ELSE 0 END) AS judge_lower,
    SUM(CASE WHEN j.judge_score > j.human_score THEN 1 ELSE 0 END) AS judge_higher,
    ROUND(100.0 * SUM(CASE WHEN j.judge_score < j.human_score THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_judge_lower
FROM judge_scores AS j
JOIN models AS m
    ON m.model_id = j.model_id
GROUP BY m.model_name
ORDER BY human_mean DESC;

-- Part 2: both models together (no GROUP BY = one overall row)
SELECT
    COUNT(*)                                                AS answers,
    ROUND(AVG(j.human_score), 2)                            AS human_mean,
    ROUND(AVG(j.judge_score), 2)                            AS judge_mean,
    ROUND(AVG(j.judge_score - j.human_score), 2)            AS mean_gap,
    SUM(CASE WHEN j.judge_score < j.human_score THEN 1 ELSE 0 END) AS judge_lower,
    SUM(CASE WHEN j.judge_score > j.human_score THEN 1 ELSE 0 END) AS judge_higher,
    ROUND(100.0 * SUM(CASE WHEN j.judge_score < j.human_score THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_judge_lower
FROM judge_scores AS j;