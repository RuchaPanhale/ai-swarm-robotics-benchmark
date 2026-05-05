# AI Swarm Robotics Benchmark

A benchmark project for evaluating how well large language models (LLMs) understand, reason about, and respond to autonomous swarm robotics scenarios, especially in safety-critical domains.

## Overview

Large language models are increasingly used for reasoning, planning, and decision support. However, their understanding of autonomous swarm robotics remains underexplored. This project aims to build a benchmark that tests LLM performance on scenario-based questions related to swarm behavior, safety, coordination, and ethical decision-making.

## Objectives

- Design realistic autonomous swarm robotics scenarios across multiple domains
- Evaluate LLM responses on technical, safety, and ethical dimensions
- Compare model strengths, weaknesses, and failure patterns
- Build a structured benchmark for future research in AI and robotics evaluation
- Compare AI vs Human evaluation using DeepSeek to score ChatGPT & Claude's answers

## Project Scope

This benchmark focuses on text-based scenarios involving autonomous robotic swarms in domains such as:

- Disaster response
- Flood rescue and medical aid delivery
- Environmental monitoring
- Security surveillance
- Search and rescue
- Underwater Exploration
- Safety-critical public operations

## Methodology

The project is being developed in the following stages:

1. Scenario design  
2. Question generation  
3. Prompt design  
4. LLM response collection  
5. Evaluation using defined rubrics  
6. Comparative analysis of results

## LLMs tested 
1. ChatGPT 5.3
2. Claude Sonnet 4.6
3. Gemini 3 flash
4. Perplexity Sonar
5. Used Deepseek V4 Pro to compare AI vs human scoring

## Evaluation Criteria

LLM responses may be evaluated on:

- Technical correctness
- Safety awareness
- Ethical reasoning
- Hallucination or unsupported assumptions
- Clarity of justification
- Confidence vs. overconfidence

## Planned Tech Stack

- Python
- Google Colab / Jupyter Notebook
- CSV / JSON for benchmark data
- Prompt-based LLM evaluation
- Data visualization tools

## Repository Structure

```text
ai-swarm-robotics-benchmark/
│── README.md
│── notebooks/
│── data/
│── prompts/
│── evaluation/
│── results/
│── docs/
