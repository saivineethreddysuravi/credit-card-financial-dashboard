-- ==============================================================================
-- Enterprise Credit Risk & Portfolio Health Analytics
-- Advanced Analytics Module (Tier-1 FAANG/FinTech SQL)
-- ==============================================================================
-- 
-- Objectives:
-- 1. Cohort Analysis: Track retention and spending behavior over time.
-- 2. Risk Segmentation: Identify high-risk clusters using window functions.
-- 3. Revenue Intelligence: Analyze 'Share of Wallet' and acquisition efficiency.
-- 4. Rolling Metrics: 30-Day moving averages for volatility tracking.
--
-- Tables Used: 
-- - fact_credit_card_metrics (Transactions, Balance, Limits)
-- - dim_customer (Demographics, Income, Job)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. REVENUE INTELLIGENCE: Customer Lifetime Value (CLV) Proxy & Acquisition Efficiency
-- ------------------------------------------------------------------------------
-- Business Question: Which customer segments yield the highest ROI relative to their acquisition cost?

WITH CustomerFinancials AS (
    SELECT 
        d.client_id,
        d.income_segment,
        d.education_level,
        SUM(f.annual_fees + f.interest_earned) AS total_revenue,
        SUM(f.total_trans_amt) AS lifetime_spend,
        -- Assumption: Acquisition cost is available in a staging table or standard rate per card type
        -- Using a proxy here based on card type for demonstration
        CASE 
            WHEN f.card_type = 'Blue' THEN 50
            WHEN f.card_type = 'Silver' THEN 100
            WHEN f.card_type = 'Gold' THEN 200
            WHEN f.card_type = 'Platinum' THEN 500
            ELSE 50
        END AS estimated_acquisition_cost
    FROM fact_credit_card_metrics f
    JOIN dim_customer d ON f.client_id = d.client_id
    GROUP BY d.client_id, d.income_segment, d.education_level, f.card_type
)
SELECT 
    income_segment,
    education_level,
    COUNT(client_id) AS customer_count,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_user,
    ROUND(AVG(lifetime_spend), 2) AS avg_spend,
    ROUND(AVG(total_revenue - estimated_acquisition_cost), 2) AS avg_net_profit,
    ROUND((SUM(total_revenue - estimated_acquisition_cost) / SUM(estimated_acquisition_cost)) * 100, 2) AS roi_percentage
FROM CustomerFinancials
GROUP BY income_segment, education_level
ORDER BY roi_percentage DESC;


-- ------------------------------------------------------------------------------
-- 2. RISK SEGMENTATION: Delinquency Probability using Window Functions
-- ------------------------------------------------------------------------------
-- Business Question: Identify customers who are 'on the edge' based on utilization spikes.
-- Logic: Compare current utilization vs. their 3-month moving average.

WITH MonthlyUtilization AS (
    SELECT 
        client_id,
        week_start_date,
        utilization_ratio,
        -- Calculate 4-week (approx 1 month) moving average of utilization
        AVG(utilization_ratio) OVER (
            PARTITION BY client_id 
            ORDER BY week_start_date 
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) AS moving_avg_utilization
    FROM fact_credit_card_metrics
),
RiskFlags AS (
    SELECT 
        client_id,
        week_start_date,
        utilization_ratio,
        moving_avg_utilization,
        -- Flag if current utilization surges > 20% over the moving average
        CASE 
            WHEN utilization_ratio > (moving_avg_utilization * 1.20) THEN 1 
            ELSE 0 
        END AS sudden_spike_flag
    FROM MonthlyUtilization
)
SELECT 
    r.client_id,
    c.state_code,
    c.job_type,
    COUNT(r.sudden_spike_flag) AS total_risk_events
FROM RiskFlags r
JOIN dim_customer c ON r.client_id = c.client_id
WHERE r.sudden_spike_flag = 1
GROUP BY r.client_id, c.state_code, c.job_type
HAVING COUNT(r.sudden_spike_flag) >= 2 -- Focus on repeat offenders
ORDER BY total_risk_events DESC
LIMIT 100;


-- ------------------------------------------------------------------------------
-- 3. COHORT ANALYSIS: Transaction Volume Retention
-- ------------------------------------------------------------------------------
-- Business Question: Do newer customers transact as frequently as older cohorts?

WITH CohortDefinition AS (
    SELECT 
        client_id,
        MIN(DATE_TRUNC('month', week_start_date)) AS cohort_month
    FROM fact_credit_card_metrics
    GROUP BY client_id
),
CustomerActivities AS (
    SELECT 
        f.client_id,
        DATE_TRUNC('month', f.week_start_date) AS activity_month,
        f.total_trans_amt
    FROM fact_credit_card_metrics f
)
SELECT 
    cd.cohort_month,
    ca.activity_month,
    -- Calculate the month index (0 = first month, 1 = second month...)
    FLOOR(DATE_PART('day', ca.activity_month - cd.cohort_month) / 30) AS month_index,
    COUNT(DISTINCT ca.client_id) AS active_customers,
    SUM(ca.total_trans_amt) AS total_cohort_spend
FROM CohortDefinition cd
JOIN CustomerActivities ca ON cd.client_id = ca.client_id
GROUP BY cd.cohort_month, ca.activity_month
ORDER BY cd.cohort_month, month_index;


-- ------------------------------------------------------------------------------
-- 4. SPENDING PATTERNS: 'Share of Wallet' by Expenditure Type
-- ------------------------------------------------------------------------------
-- Business Question: How does spending mix shift across income segments?

SELECT 
    d.income_segment,
    f.expenditure_type,
    SUM(f.total_trans_amt) AS segment_spend,
    SUM(SUM(f.total_trans_amt)) OVER (PARTITION BY d.income_segment) AS total_segment_spend,
    ROUND(
        (SUM(f.total_trans_amt) / SUM(SUM(f.total_trans_amt)) OVER (PARTITION BY d.income_segment)) * 100, 
    2) AS share_of_wallet_pct
FROM fact_credit_card_metrics f
JOIN dim_customer d ON f.client_id = d.client_id
GROUP BY d.income_segment, f.expenditure_type
ORDER BY d.income_segment, share_of_wallet_pct DESC;


-- ------------------------------------------------------------------------------
-- 5. CHURN PREDICTION: Inactivity Watchlist (High Value At-Risk)
-- ------------------------------------------------------------------------------
-- Business Question: Which high-value customers have stopped transacting recently?
-- Logic: Customers with > $5k lifetime spend but 0 transactions in the last 60 days.

WITH MaxTransactionDate AS (
    SELECT MAX(week_start_date) as max_date FROM fact_credit_card_metrics
),
CustomerStats AS (
    SELECT 
        client_id,
        SUM(total_trans_amt) as lifetime_spend,
        MAX(week_start_date) as last_seen_date
    FROM fact_credit_card_metrics
    GROUP BY client_id
)
SELECT 
    cs.client_id,
    cs.lifetime_spend,
    cs.last_seen_date,
    (SELECT max_date FROM MaxTransactionDate) - cs.last_seen_date as days_inactive
FROM CustomerStats cs
WHERE cs.lifetime_spend > 5000 -- High Value Threshold
  AND ((SELECT max_date FROM MaxTransactionDate) - cs.last_seen_date) > 60 -- At Risk Threshold
ORDER BY days_inactive DESC, lifetime_spend DESC;
