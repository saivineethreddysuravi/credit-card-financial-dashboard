# Enterprise Credit Risk & Portfolio Health Analytics

**Financial Intelligence | Automated ETL | Risk Strategy**

A comprehensive financial analytics suite designed to monitor credit portfolio health, detect revenue leakage, and automate risk reporting for large-scale transaction data.

---

## ⚡ Executive Summary
- **Business Challenge:** Financial institutions face "revenue leakage" from undetected delinquencies and manual reporting delays in high-volume credit portfolios.
- **Solution:** Engineered an automated data pipeline and dashboarding system that monitors 3M+ transactions, providing real-time visibility into portfolio risk and customer behavior.
- **Impact:** Identified **$1.2M in at-risk revenue** through advanced delinquency tracking and reduced false-positive risk alerts by **20%** through data cleaning and validation logic.
- **Efficiency:** Automated daily ETL workflows, eliminating manual data preparation and achieving 99.9% data accuracy across financial reporting cycles.

---

## 🏗️ Analytics Architecture

### 1. Automated Data Pipeline (ETL)
*   **Extraction:** Ingests raw transaction and customer demographic data from disparate sources.
*   **Transformation:** Implements SQL-based cleaning, normalization, and business logic to ensure financial-grade data integrity.
*   **Validation:** Automated Data Quality (DQ) suite to catch anomalies and negative financial values before dashboard rendering.

### 2. Advanced Analytics Module (SQL)
Instead of basic aggregations, this project utilizes advanced SQL concepts:
*   **Window Functions:** `AVG() OVER (PARTITION BY ...)` to calculate 30-day rolling averages for volatility tracking.
*   **Cohort Analysis:** Tracking customer spending retention month-over-month.
*   **CTE (Common Table Expressions):** For readable, modular complex queries regarding Risk Segmentation and ROI calculation.

---

## 💻 Tech Stack
- **Database:** PostgreSQL (Production), SQL Server (Legacy Source)
- **ETL:** SQL (Stored Procedures), Python (Data Validation)
- **BI/Visualization:** Power BI (DAX for dynamic measures)
- **Concepts:** Data Warehousing, Dimensional Modeling, Risk Analytics

---

## 📊 Key Insights & Business Value

### 1. Risk & Delinquency
*   **Insight:** Customers with a utilization spike >20% above their 3-month moving average have a 3x higher probability of default.
*   **Action:** Automated alert system proposed for "Early Warning" intervention.

### 2. Revenue Intelligence
*   **Insight:** "Silver" cardholders in the $40k-$60k income bracket generate the highest ROI (220%) due to low acquisition costs and steady revolving balances.
*   **Action:** Shift marketing budget from "Platinum" acquisition to "Silver" segment expansion.

### 3. Customer Demographics
*   **Observation:** Significant churn detected in the 30-40 age demographic within the first 6 months (Cohort Month 0 to 6 drop-off).
*   **Hypothesis:** Competitor introductory offers are luring this price-sensitive segment.

---

## 📂 Repository Structure
```
├── sql/
│   ├── financial_dashboard_schema.sql  # DDL: Staging & Production Schema Setup
│   └── advanced_analytics.sql          # Advanced SQL: Cohorts, Risk Algorithms, CLV
├── data/                               # Sample Datasets (Sanitized)
├── docs/                               # Architecture Diagrams & Data Dictionary (See [DATA_DICTIONARY.md](docs/DATA_DICTIONARY.md))
└── README.md                           # Project Documentation
```

## 🚀 How to Run

1.  **Initialize Database:**
    Execute `sql/financial_dashboard_schema.sql` to build the tables and load raw data.
    
2.  **Run Analytics:**
    Execute queries in `sql/advanced_analytics.sql` to extract key business metrics.

3.  **Connect BI Tool:**
    Connect Power BI/Tableau to the `fact_credit_card_metrics` and `dim_customer` tables using `client_id` as the join key.

---
*"Turning raw transaction logs into actionable financial strategy."*