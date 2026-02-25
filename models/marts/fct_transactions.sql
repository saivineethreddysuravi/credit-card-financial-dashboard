-- Marts Model: fct_transactions.sql
-- Description: Aggregate transaction history with customer risk tier logic.

WITH stg_transactions AS (
    SELECT * FROM {{ ref('stg_transactions') }}
),

stg_customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

fct_transactions AS (
    SELECT
        t.transaction_id,
        t.customer_id,
        t.transaction_date,
        t.amount,
        t.merchant_category,
        t.is_fraud,
        c.risk_tier,
        c.annual_income_usd,
        -- Calculate utilization ratio for this transaction
        (t.amount / c.annual_income_usd) * 100 AS utilization_pct,
        -- Flag high-risk transactions
        CASE
            WHEN t.amount > 5000 AND c.risk_tier = 'High Risk' THEN 1
            ELSE 0
        END AS requires_review_flag
    FROM stg_transactions t
    LEFT JOIN stg_customers c
        ON t.customer_id = c.customer_id
    WHERE t.transaction_date >= DATEADD(YEAR, -5, CURRENT_DATE())
)

SELECT * FROM fct_transactions;
