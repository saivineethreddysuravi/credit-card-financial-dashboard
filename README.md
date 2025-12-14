# Credit Card Financial Dashboard 💳

A full-stack data analytics project that simulates an end-to-end business intelligence pipeline. It handles "messy" raw data, processes it through a SQL-based ETL pipeline, and visualizes the results in Power BI.

## 📊 Project Architecture (The "Full Stack" Flow)

This project demonstrates the complete lifecycle of data, "from messy CSVs to actionable dashboard":

1.  **Raw Data Layer (Messy):**
    *   Input: `data/*.csv` files containing unformatted dates, inconsistent strings (e.g., "Selfemployeed"), and mixed types.
    *   Simulation: These represent raw extracts from a legacy banking system.
2.  **Staging Layer (Ingestion):**
    *   Tool: **PostgreSQL**.
    *   Action: Raw data is loaded into `staging_` tables as `VARCHAR` text to prevent load errors.
3.  **Transformation Layer (Cleaning):**
    *   Tool: **SQL (ETL)**.
    *   Logic:
        *   **Date Parsing:** Converting 'DD-MM-YYYY' strings to proper SQL `DATE` objects.
        *   **Typo Fixing:** Correcting "Selfemployeed" to "Self-Employed", Trimming whitespace from "Chip ".
        *   **Type Casting:** Converting 'yes'/'no' fields to `BOOLEAN`, strings to `DECIMAL`.
        *   **Standardization:** Mapping NULLs or 'Unknown' values.
4.  **Production Layer (Gold):**
    *   Output: Clean, optimized tables (`dim_customer`, `fact_credit_card_metrics`) ready for high-performance querying.
5.  **Visualization Layer:**
    *   Tool: **Power BI**.
    *   Action: Connects to the Production Layer to render the dashboard.

## 💡 Key Metrics & Insights

-   **Revenue Analysis:** Tracked quarterly revenue and total transaction volume, identifying Q4 as the peak season.
-   **Customer Segmentation:** Analyzed demographics to identify high-value segments (e.g., Businessmen).
-   **Card Performance:** Identified 'Blue' cards as the volume leader.
-   **Risk:** Monitored delinquency rates via the `is_delinquent` flag derived in the ETL process.

## 🛠️ Tools & Technologies

-   **Database:** PostgreSQL (Staging -> Production architecture).
-   **ETL:** SQL Stored Procedures / Scripts for data cleaning.
-   **Visualization:** Power BI / Tableau.
-   **Language:** SQL (Advanced DDL/DML), DAX.

## 📂 Project Structure

```
credit-card-financial-dashboard/
├── data/
│   ├── credit_card.csv       # Raw Transaction Data (Messy)
│   └── customer.csv          # Raw Customer Data (Messy)
├── docs/                     # PDF Dashboard Exports
├── sql/
│   └── financial_dashboard_schema.sql  # The COMPLETE Pipeline (DDL + Transformation Logic)
└── README.md
```

## 🚀 How to Run the Pipeline

1.  **Setup Database:**
    *   Create a PostgreSQL database named `credit_card_db`.
2.  **Execute SQL Pipeline:**
    *   Run the script `sql/financial_dashboard_schema.sql`.
    *   *Note:* You will need to uncomment the `COPY` commands in the script and provide the absolute path to the `data/` CSV files on your machine.
3.  **Connect Power BI:**
    *   Connect Power BI to the `credit_card_db`.
    *   Import tables `dim_customer` and `fact_credit_card_metrics`.
4.  **Refresh:**
    *   The dashboard will now reflect the clean, transformed data.
