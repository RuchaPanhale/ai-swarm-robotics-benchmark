"""
Build tidy CSV tables from the benchmark spreadsheet for PostgreSQL.

Reads data/dataset_swarm_llm_benchmark.xlsx (read-only: the spreadsheet is never modified)
and writes NEW files to data/tidy/. Nothing else in the repo is changed.

Run from the repo root:
    python scripts/tidy_tables.py
"""
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
XLSX = ROOT / "data" / "dataset_swarm_llm_benchmark.xlsx"
OUT = ROOT / "data" / "tidy"

# sheet name -> (short id, full model name)
MODELS = {
    "ChatGPT": ("chatgpt", "ChatGPT 5.3 Instant"),
    "Claude": ("claude", "Claude Sonnet 4.6"),
    "Gemini": ("gemini", "Gemini 3 Flash"),
    "Perplexity AI": ("perplexity", "Perplexity AI Sonar"),
}
# rubric maximum per metric (higher is always better)
MAX_POINTS = {
    "Technical_Accuracy": 2, "Safety_Awareness": 2, "Ethical_Awareness": 2,
    "Reasoning_Clarity": 2, "Hallucination": 1, "Overconfidence": 1,
}
METRICS = list(MAX_POINTS)
# judge sheet: model sheet -> (human column, DeepSeek V4 Pro column)
JUDGE_COLS = {
    "Claude": ("Human score", "Deepseek score"),
    "ChatGPT": ("Human score.1", "Deepseek score.1"),
}


def clean_cols(df):
    """Same header cleanup as notebooks/data_analysis.ipynb."""
    df.columns = df.columns.str.strip().str.replace(" ", "_")
    return df


# ---------- questions ----------
q = clean_cols(pd.read_excel(XLSX, sheet_name="text&ids"))
q[["Domain", "Scenario_ID"]] = q[["Domain", "Scenario_ID"]].ffill()
q = q.dropna(subset=["Question_ID"])
questions = pd.DataFrame({
    "question_id": q["Question_ID"].astype(str).str.strip(),
    "scenario_id": q["Scenario_ID"].astype(str).str.strip(),
    "domain": q["Domain"].astype(str).str.strip(),
    "question_type": q["Question_Type"].astype(str).str.strip(),
})
assert len(questions) == 54, f"Expected 54 questions, got {len(questions)}"
assert questions["question_id"].is_unique, "Duplicate Question_IDs in text&ids"
valid_ids = set(questions["question_id"])

# ---------- models ----------
models = pd.DataFrame(
    [(mid, name) for mid, name in MODELS.values()],
    columns=["model_id", "model_name"],
)

# ---------- responses ----------
frames, sheet_order = [], {}
for sheet, (model_id, _) in MODELS.items():
    df = clean_cols(pd.read_excel(XLSX, sheet_name=sheet))
    df[["Domain", "Scenario_id"]] = df[["Domain", "Scenario_id"]].ffill()
    df = df.rename(columns={df.columns[3]: "Answer"})
    df = df.dropna(subset=["Question_id"])
    df["Question_id"] = df["Question_id"].astype(str).str.strip()

    assert len(df) == 54, f"{sheet}: expected 54 rows, got {len(df)}"
    assert set(df["Question_id"]) == valid_ids, f"{sheet}: Question_ids don't match text&ids"
    for m, mx in MAX_POINTS.items():
        df[m] = df[m].astype(int)
        assert df[m].between(0, mx).all(), f"{sheet}: {m} outside 0-{mx}"
    df["Total"] = df["Total"].astype(int)
    assert (df[METRICS].sum(axis=1) == df["Total"]).all(), f"{sheet}: Total != sum of metrics"

    sheet_order[sheet] = df[["Question_id", "Total"]].reset_index(drop=True)
    frames.append(pd.DataFrame({
        "model_id": model_id,
        "question_id": df["Question_id"],
        "answer": df["Answer"],
        "technical_accuracy": df["Technical_Accuracy"],
        "safety_awareness": df["Safety_Awareness"],
        "ethical_awareness": df["Ethical_Awareness"],
        "reasoning_clarity": df["Reasoning_Clarity"],
        "hallucination": df["Hallucination"],
        "overconfidence": df["Overconfidence"],
        "total_score": df["Total"],
    }))
responses = pd.concat(frames, ignore_index=True)
assert len(responses) == 216, f"Expected 216 responses, got {len(responses)}"

# ---------- judge_scores ----------
# The judge sheet has no ID column, so we check that its human scores match the
# model sheet's totals row by row before attaching question IDs. If they don't match,
# the script stops and writes nothing.
j = pd.read_excel(XLSX, sheet_name="DS-ai vs us")
judge_frames = []
for sheet, (hcol, dcol) in JUDGE_COLS.items():
    pair = j[[hcol, dcol]].dropna().reset_index(drop=True).astype(int)
    ref = sheet_order[sheet]
    assert len(pair) == 54, f"Judge sheet ({sheet}): expected 54 rows, got {len(pair)}"
    assert (pair[hcol] == ref["Total"]).all(), (
        f"Judge sheet ({sheet}): human scores don't line up with the {sheet} sheet order"
    )
    judge_frames.append(pd.DataFrame({
        "model_id": MODELS[sheet][0],
        "question_id": ref["Question_id"],
        "human_score": pair[hcol],
        "judge_score": pair[dcol],
    }))
judge = pd.concat(judge_frames, ignore_index=True)
assert len(judge) == 108

# ---------- write (only after every check passed) ----------
OUT.mkdir(parents=True, exist_ok=True)
models.to_csv(OUT / "models.csv", index=False)
questions.to_csv(OUT / "questions.csv", index=False)
responses.to_csv(OUT / "responses.csv", index=False)
judge.to_csv(OUT / "judge_scores.csv", index=False)
print("All checks passed. Wrote:")
for name, d in [("models", models), ("questions", questions),
                ("responses", responses), ("judge_scores", judge)]:
    print(f"  data/tidy/{name}.csv  ({len(d)} rows)")