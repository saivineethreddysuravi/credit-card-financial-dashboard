-- ==============================================================================
-- Day 8: Performance Optimization - Enterprise Credit Risk Analytics
-- Target Platform: Snowflake
-- Objective: Optimize query performance for 3M+ transaction table via 
--            Clustering Keys and Search Optimization Service (SOS).
-- ==============================================================================

-- 1. Analyze Current Clustering Depth & Overlap
-- Before applying a cluster key, we verify current performance metrics.
SELECT SYSTEM$CLUSTERING_INFORMATION('marts.fct_transactions', '(transaction_date, account_id)');

-- 2. Apply Clustering Keys for Time-Series and Account Lookups
-- Why: Most risk queries filter by date range and join on account ID. 
-- Grouping data by these columns minimizes partition scanning.
ALTER TABLE marts.fct_transactions 
CLUSTER BY (transaction_date, account_id);

-- 3. Enable Search Optimization Service (SOS) for High-Selectivity Point Lookups
-- Why: Fraud detection requires real-time lookup of specific transaction IDs or IP addresses 
-- which bypasses clustering benefits. SOS builds an index-like structure for this.
ALTER TABLE marts.fct_transactions 
ADD SEARCH OPTIMIZATION ON EQUALITY(transaction_id, ip_address);

-- 4. Create Materialized View for Daily Risk Aggregation
-- Why: Dashboard loads are slow when computing daily risk aggregates from 3M+ rows.
-- Pre-computing the aggregates shifts cost from query time to insert/update time.
CREATE OR REPLACE MATERIALIZED VIEW marts.mv_daily_risk_metrics
CLUSTER BY (transaction_date)
AS
SELECT 
    transaction_date,
    risk_score_band,
    COUNT(transaction_id) as total_transactions,
    SUM(transaction_amount) as total_volume,
    SUM(CASE WHEN is_fraud_flag = TRUE THEN transaction_amount ELSE 0 END) as at_risk_revenue
FROM marts.fct_transactions
GROUP BY 1, 2;

-- 5. Monitor Auto-Clustering and Materialized View Maintenance Costs
-- Establish a governance check on credit consumption for the optimizations.
SELECT 
    start_time,
    end_time,
    credits_used
FROM table(information_schema.metering_history(dateAdd(days, -7, current_date())))
WHERE service_type IN ('AUTO_CLUSTERING', 'MATERIALIZED_VIEW_MAINTENANCE')
ORDER BY start_time DESC;
