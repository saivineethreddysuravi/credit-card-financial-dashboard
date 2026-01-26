-- ==============================================================================
-- Full Stack Data Analytics Project: Credit Card Financial Dashboard
-- Step 4: Analytical Views for Power BI / Tableau
-- ==============================================================================

-- View 1: Weekly Key Performance Indicators (KPIs)
-- Aggregates metrics by week to track trends over time.
DROP VIEW IF EXISTS vw_weekly_kpis;
CREATE VIEW vw_weekly_kpis AS
SELECT 
    week_start_date,
    COUNT(transaction_id) as total_transactions,
    SUM(total_trans_amt) as total_revenue,
    SUM(interest_earned) as total_interest,
    AVG(utilization_ratio) as avg_utilization,
    SUM(CASE WHEN is_delinquent THEN 1 ELSE 0 END) as delinquent_accounts
FROM fact_credit_card_metrics
GROUP BY week_start_date
ORDER BY week_start_date;

-- View 2: Customer Segmentation Analysis
-- Joins Fact and Dim tables to analyze revenue by customer demographics.
DROP VIEW IF EXISTS vw_customer_segmentation;
CREATE VIEW vw_customer_segmentation AS
SELECT 
    c.income_segment,
    c.education_level,
    c.job_type,
    COUNT(DISTINCT f.client_id) as customer_count,
    SUM(f.total_trans_amt) as total_spend,
    AVG(f.credit_limit) as avg_credit_limit
FROM fact_credit_card_metrics f
JOIN dim_customer c ON f.client_id = c.client_id
GROUP BY c.income_segment, c.education_level, c.job_type;

-- View 3: Delinquency Risk Report
-- Identifies high-risk segments based on delinquency rates.
DROP VIEW IF EXISTS vw_risk_report;
CREATE VIEW vw_risk_report AS
SELECT 
    state_code,
    card_type,
    COUNT(*) as total_accounts,
    SUM(CASE WHEN is_delinquent THEN 1 ELSE 0 END) as delinquent_count,
    (CAST(SUM(CASE WHEN is_delinquent THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100 as delinquency_rate
FROM fact_credit_card_metrics f
JOIN dim_customer c ON f.client_id = c.client_id
GROUP BY state_code, card_type
HAVING COUNT(*) > 10 -- Filter for statistical relevance
ORDER BY delinquency_rate DESC;
