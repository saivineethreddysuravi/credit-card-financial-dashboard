# Credit Card Financial Dashboard 💳

A comprehensive financial dashboard providing real-time insights into credit card operations, customer demographics, and transaction trends using SQL and PowerBI.

## 📊 Project Overview

**Objective:** To develop a weekly credit card dashboard that provides real-time insights into key performance metrics and trends, enabling stakeholders to monitor operations effectively.

**Business Goal:** Streamline data processing and visualization to support decision-making regarding customer acquisition, revenue growth, and risk management.

## 💡 Key Metrics & Insights

- **Revenue Analysis:** Tracked quarterly revenue and total transaction volume, identifying Q4 as the peak season.
- **Customer Segmentation:** Analyzed customer demographics (Age, Income, Job) to identify high-value segments (e.g., Businessmen and Blue-collar workers).
- **Card Performance:** compared Blue, Silver, Gold, and Platinum cards; identified 'Blue' cards as contributing the highest transaction volume.
- **Delinquency Risk:** Monitored activation rates and delinquent account percentages to assess credit risk.

## 🛠️ Tools & Technologies

- **PostgreSQL:** Database for storing and querying 10,000+ transaction and customer records.
- **Power BI / Tableau:** Visualization tool for creating interactive dashboards (PDF reports included in `docs/`).
- **DAX:** Used for calculating custom measures like 'Week-over-Week Revenue Growth'.
- **CSV/Excel:** Initial data sources.

## 📂 Project Structure

```
credit-card-financial-dashboard/
├── README.md               # Project documentation
├── data/                   # Raw CSV data files (Customer & Transaction data)
├── docs/                   # PDF exports of the final dashboard
└── sql/                    # SQL scripts for data import and transformation
```

## 🔄 Data Pipeline

1.  **Data Ingestion:** Raw CSV data (`credit_card.csv`, `customer.csv`) imported into SQL database.
2.  **Data Cleaning:** SQL queries used to filter nulls, format dates, and categorize transaction types.
3.  **Visualization:** Connected BI tool to SQL database to build reports.
4.  **Updates:** Weekly CSV updates (`cc_add.csv`, `cust_add.csv`) processed to refresh the dashboard.

## 🚀 How to Use

1.  **View Reports:** Check the `docs/` folder for PDF versions of the dashboard.
2.  **Data Analysis:** Import the CSV files from `data/` into your preferred SQL tool using the schema in `sql/`.
3.  **Reproduction:** Load the data into PowerBI/Tableau to recreate the visualizations based on the fields provided.

## 📌 Future Enhancements

-   Automate the weekly data import process using Python/Airflow.
-   Add predictive analytics to forecast next month's revenue.