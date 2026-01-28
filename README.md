# ai-literacy-eurostat-2025
Country-level AI Literacy Index (2025) from Eurostat: AI use vs. barriers, typology, and visual analysis.
# AI Literacy Index (Eurostat, 2025)

This repository contains a country-level analysis of **AI literacy** across European countries using **Eurostat (2025)** data.

The project constructs a composite **AI Literacy Index** based on:
- **AI use** (share of individuals using generative AI tools)
- **Barriers to AI use** (reasons for non-use)

The analysis produces a typology of countries and visualizes structural differences in AI adoption capacity.

---

## 📊 Data Sources

All data come from **Eurostat**:

- `useofai.csv`  
  *Use of generative AI tools: in the last 3 months*  
  (% of individuals, 2025)

- `notuseofai.csv`  
  *Reasons for not using generative AI tools*  
  (% of individuals, averaged across reasons, 2025)

Only:
- Annual data  
- All individuals  
- Percentage of individuals  
are retained.

EU aggregates (EU27, Euro area) are excluded.

---

## 🧠 Methodology

### 1. Data Cleaning
- Filter to 2025
- Select relevant indicators
- Remove EU-level aggregates
- Keep one observation per country

### 2. Barrier Index
- Average all non-use reasons per country
- Higher values indicate **stronger barriers**

### 3. Normalization
Both components are normalized to the [0,1] range:

use_norm = (use - min(use)) / (max(use) - min(use))
barrier_norm = (barrier - min(barrier)) / (max(barrier) - min(barrier))

### 4. AI Literacy Index

AI_Literacy = use_norm − barrier_norm

Higher values indicate higher effective AI literacy.

---

## 🗂 Country Typology

Countries are classified using median splits:

| Typology | Description |
|--------|------------|
| 1 | High AI use – Low barriers |
| 2 | High AI use – High barriers |
| 3 | Low AI use – Low barriers |
| 4 | Low AI use – High barriers |

---

## 📈 Outputs

The analysis produces:
- Country rankings by AI literacy
- Typology-level averages
- Correlation and regression analysis
- Visualizations (bar charts, scatter plots, distributions)

All figures are saved in:
outputs/figures/

---

## 🧪 Reproducibility

The entire pipeline is fully reproducible in **Stata 17**.

Run scripts in order:

code/01_build_clean_datasets.do
code/02_build_merged_index.do
code/03_analysis_and_figures.do

---

## ⚠️ Notes

- The AI Literacy Index is an **exploratory composite indicator**
- It is not an official Eurostat index
- Results should be interpreted comparatively, not normatively

---

## 👤 Author

Prepared by **İlayda Acırlı**  
For academic and portfolio use.

---

## 📜 License

MIT License
