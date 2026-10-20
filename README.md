# Prospective Forecasting in Real-World Markets: Chinese and US Large Language Models Against Human Forecasters and Market Benchmarks

Open-source supplementary materials, datasets, raw conversation logs, and R code for manuscript **IPM-D-26-05573**.

---

## 📂 Repository Structure
- **`Prompts_Bsc.docx`**: Basic prompts for 447 individual matches (English & Chinese).
- **`Prompts_Pro.docx`**: Information-enriched prompts for 447 individual matches (English & Chinese).
- **`dataset_1006_matches.csv`**: Historical calibration dataset (1,006 matches) for prompt feature selection.
- **`dataset_447_matches.xlsx`**: Primary prospective forecasting dataset (447 matches, 28 LLM configs & 4 benchmarks).
- **`conversations.json`**: Raw platform-exported conversation logs with millisecond-level ISO 8601 timestamps.
- **`deepseek_data-2026-10-16.zip`**: Native export archive from DeepSeek web interface containing `conversations.json`.
- **`R-Code`**: Main R analysis script for model evaluations, metrics, and visualization.
- **`R-Code_statistic-tests`**: R script executing match-level paired tests (McNemar, paired t-tests) & FDR control.

---

## 🔒 Data Integrity & Cryptographic Verification
To ensure temporal integrity and prevent retrospective contamination, local OS SHA-256 checksums for the raw export files are:
- `conversations.json`: `8b62c8e24b5b86269443068450e9743e77588d166fd9d6a5126c24501f3592c8`
- `deepseek_data-2026-10-16.zip`: `db236de0576fa6142f3873257d650a257d650aed669b186733904225686d350f00a64269`

---

## 📜 Data Availability Statement
All data, code, and timestamp logs are publicly archived to ensure full empirical reproducibility.
