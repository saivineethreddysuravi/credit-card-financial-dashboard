-- Staging Model: stg_customers.sql
-- Description: Clean and standardize raw customer demographic and financial data.

WITH raw_customers AS (
    SELECT * FROM {{ source('raw', 'customer_data') }}
),

cleaned_customers AS (
    SELECT
        CAST(customer_id AS VARCHAR) AS customer_id,
        TRIM(UPPER(first_name)) AS first_name,
        TRIM(UPPER(last_name)) AS last_name,
        CAST(age AS INT) AS age_group,
        CAST(annual_income AS DECIMAL(10, 2)) AS annual_income_usd,
        COALESCE(credit_score, 0) AS credit_score,
        -- Calculate risk tier based on credit score
        CASE
            WHEN credit_score >= 750 THEN 'Low Risk'
            WHEN credit_score BETWEEN 650 AND 749 THEN 'Medium Risk'
            ELSE 'High Risk'
        END AS risk_tier,
        CAST(created_at AS TIMESTAMP) AS account_created_at
    FROM raw_customers
    WHERE customer_id IS NOT NULL
)

SELECT * FROM cleaned_customers;
