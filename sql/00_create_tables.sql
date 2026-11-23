-- 00_create_tables.sql
-- Creates 4 tables and loads them from the CSV files in data/tidy/.
-- Run from the repo root:  psql -d swarm_benchmark -f sql/00_create_tables.sql
-- Safe to re-run: it deletes and rebuilds only these 4 tables.

DROP TABLE IF EXISTS judge_scores;
DROP TABLE IF EXISTS responses;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS models;

-- The 4 models
CREATE TABLE models (
    model_id   TEXT PRIMARY KEY,
    model_name TEXT NOT NULL
);

-- The 54 benchmark questions
CREATE TABLE questions (
    question_id   TEXT PRIMARY KEY,
    scenario_id   TEXT NOT NULL,
    domain        TEXT NOT NULL,
    question_type TEXT NOT NULL
);

-- One row = one model's answer to one question (216 rows)
-- Higher is always better. For hallucination and overconfidence: 1 = not present (good), 0 = present (bad).
CREATE TABLE responses (
    model_id           TEXT NOT NULL REFERENCES models (model_id),
    question_id        TEXT NOT NULL REFERENCES questions (question_id),
    answer             TEXT,
    technical_accuracy INTEGER NOT NULL,
    safety_awareness   INTEGER NOT NULL,
    ethical_awareness  INTEGER NOT NULL,
    reasoning_clarity  INTEGER NOT NULL,
    hallucination      INTEGER NOT NULL,
    overconfidence     INTEGER NOT NULL,
    total_score        INTEGER NOT NULL
);

-- Human vs AI judge (DeepSeek V4 Pro) scores for the top two models (108 rows)
CREATE TABLE judge_scores (
    model_id    TEXT NOT NULL REFERENCES models (model_id),
    question_id TEXT NOT NULL REFERENCES questions (question_id),
    human_score INTEGER NOT NULL,
    judge_score INTEGER NOT NULL
);

-- Load the CSV files
\copy models       FROM 'data/tidy/models.csv'       WITH (FORMAT csv, HEADER true)
\copy questions    FROM 'data/tidy/questions.csv'    WITH (FORMAT csv, HEADER true)
\copy responses    FROM 'data/tidy/responses.csv'    WITH (FORMAT csv, HEADER true)
\copy judge_scores FROM 'data/tidy/judge_scores.csv' WITH (FORMAT csv, HEADER true)

-- Check row counts (expect 4, 54, 216, 108)
SELECT COUNT(*) AS models_rows       FROM models;
SELECT COUNT(*) AS questions_rows    FROM questions;
SELECT COUNT(*) AS responses_rows    FROM responses;
SELECT COUNT(*) AS judge_scores_rows FROM judge_scores;