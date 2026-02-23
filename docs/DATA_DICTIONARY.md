# Data Dictionary - Credit Risk Analytics

## Table: stg_customers
| Column | Type | Description |
| :--- | :--- | :--- |
| customer_id | VARCHAR | Unique identifier for each customer |
| annual_income_usd | DECIMAL | Standardized annual income in USD |
| credit_score | INTEGER | Raw credit score (300-850) |
| risk_tier | VARCHAR | Categorical risk level (Low, Medium, High) based on credit score |

## Table: fct_transactions
| Column | Type | Description |
| :--- | :--- | :--- |
| transaction_id | VARCHAR | Unique identifier for the transaction |
| utilization_pct | DECIMAL | Transaction amount as a percentage of annual income |
| requires_review_flag | INTEGER | Binary flag (1=High Risk, 0=Standard) for transactions > $5000 from High Risk customers |
