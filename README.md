# Enterprise Credit Risk & Portfolio Health Analytics

**FinTech | Credit Risk Modeling | ETL Pipeline Design**

A comprehensive end-to-end data engineering and analytics platform designed to monitor credit portfolio health, predict churn, and optimize customer acquisition strategies for a mid-sized financial institution.

---

## ⚡ Executive Summary
- **Business Challenge:** The institution faced rising delinquency rates and unclear customer profitability metrics, leading to inefficient capital allocation.
- **Solution:** Engineered a scalable ETL pipeline and a normalized data warehouse (Star Schema) to centralize 100k+ transaction records. Developed advanced SQL algorithms to detect utilization spikes and segment customers by "Net Profitability."
- **Impact:** Identified a **15% high-risk segment** using moving-average utilization tracking and proposed a targeted retention strategy for high-CLV (Customer Lifetime Value) cohorts, potentially recovering **$1.2M in annual revenue**.

---

## 🏗️ System Architecture

### 1. Data Pipeline (ETL)
*   **Staging Layer:** Raw ingestion of CSV extracts (`staging_credit_card`, `staging_customer`) into Postgres. Handling VARCHAR types for fault tolerance.
*   **Transformation Layer:** SQL-based data cleaning, casting, and validation.
    *   *Normalization:* Splitting data into Fact (Transactions) and Dimension (Customers) tables.
    *   *Data Quality:* Handling NULLs, fixing categorical typos (e.g., 'Selfemployeed' -> 'Self-Employed'), and standardizing Date formats.
*   **Production Layer:** Optimized Star Schema ready for BI tools (Power BI/Tableau).

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
├── docs/                               # Architecture Diagrams & Data Dictionary
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