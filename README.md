💳 Credit Card Financial Dashboard - USA Market
SQL • Excel • Power BI

📌 Overview

The Credit Card Financial Dashboard is a comprehensive analytics project focused on the United States market. It converts raw credit card transaction data into actionable business insights.
Using SQL, Excel, and Power BI, this dashboard tracks revenue, spending behavior, and risk indicators across various US states and demographics.

🛠️ Tech Stack & Skills
Tech	Purpose
SQL 🛢️	Cleaning, joining, and transforming data
Excel 📊	Dataset preparation, lookup tables
Power BI 📈	Dashboard design, DAX, KPIs
Data Modelling 🔗	Star schema, relationships
ETL Process 🧹	Extract → Transform → Load

🔄 Workflow (End-to-End)
1️⃣ SQL – Data Cleaning & Transformation
- Removed duplicates
- Standardized US state codes and zip codes
- Generated new metrics like Spend, Interest, Utilization
- Joined multiple tables

2️⃣ Excel – Data Preparation
- Structured clean tables
- Built dimension tables for US regions
- Performed quality checks

3️⃣ Power BI – Dashboard Development
- Designed clear visuals
- Built DAX measures
- Added slicers and drill-downs
- Created storytelling layout

🧮 SQL Query Samples
1. Total Monthly Transaction Amount
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS Month,
    SUM(transaction_amount) AS Total_Amount
FROM credit_card_data
GROUP BY Month
ORDER BY Month;

2. Customer-Level Summary
SELECT 
    customer_id,
    SUM(transaction_amount) AS Total_Spend,
    SUM(late_fee) AS Total_Late_Fee,
    AVG(credit_utilization) AS Avg_Utilization
FROM credit_card_data
GROUP BY customer_id;

3. Identify High-Risk Customers
SELECT 
    customer_id,
    COUNT(*) AS Late_Payments
FROM credit_card_data
WHERE payment_status = 'Late'
GROUP BY customer_id
HAVING Late_Payments > 3;

🧠 Key DAX Measures (Power BI)
1. Total Revenue
Total Revenue = SUM(Transactions[Revenue])

2. Average Transaction Value
Avg Transaction = AVERAGE(Transactions[Transaction_Amount])

3. On-Time Payment %
On Time % = 
DIVIDE(
    CALCULATE(COUNTROWS(Transactions), Transactions[Payment_Status] = "On-Time"),
    COUNTROWS(Transactions)
)

4. Credit Utilization %
Utilization % = AVERAGE(Transactions[Credit_Utilization])

📊 Dashboard Highlights
🔹 Total revenue overview
🔹 Month-over-month performance
🔹 State-wise spending patterns (USA)
🔹 High-risk customer identification
🔹 Card-type comparison
🔹 Segment analysis (age, gender, city)

🖼️ Dashboard Preview
<img width="1340" height="745" alt="image" src="https://github.com/user-attachments/assets/62a8aafa-dd2d-4992-a486-08e09c95a8f4" />
<img width="1336" height="748" alt="image" src="https://github.com/user-attachments/assets/866d3c17-4af9-403d-a7d8-5234d28cb7e7" />

📂 Repository Structure
Credit_Card_Financial_Dashboard/
│
├── SQL/
│   └── credit_card_queries.sql
│
├── Excel/
│   └── cleaned_dataset.xlsx
│
├── PowerBI/
│   └── credit_card_dashboard.pbix
│
├── Images/
│   └── dashboard_preview.png
│
└── README.md

🧠 What I Learned
- Writing SQL for financial datasets
- Cleaning and modelling data for BI tools
- Designing business-friendly dashboards
- Creating DAX measures
- Understanding financial KPIs like utilization and delinquency within the US credit market

🚀 How to Run
- Clone this repository
- Check SQL queries in the SQL folder
- Open Excel dataset for data mapping
- Load .pbix file in Power BI Desktop
- Explore the dashboard using slicers

🤝 Contributions
Contributions and suggestions are always welcome.

📬 Contact
Sai Vineeth Reddy Suravi
📧 saivineethreddysuravi@gmail.com
🔗 https://www.linkedin.com/in/saivineethreddysuravi/
📍 Memphis, TN
