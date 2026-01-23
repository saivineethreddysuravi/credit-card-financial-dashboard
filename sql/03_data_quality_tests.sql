-- ==============================================================================
-- Data Quality Assurance Suite (DQ)
-- Purpose: Verify data integrity after ETL load before BI consumption
-- Run this as part of the daily batch pipeline.
-- ==============================================================================

-- 1. Uniqueness Check: Duplicate Customers
-- Expectation: 0 rows
SELECT client_id, COUNT(*) as count
FROM dim_customer
GROUP BY client_id
HAVING COUNT(*) > 1;

-- 2. Null Checks: Critical Key Fields
-- Expectation: 0 rows
SELECT COUNT(*) as null_key_count
FROM fact_credit_card_metrics
WHERE client_id IS NULL 
   OR week_start_date IS NULL 
   OR card_type IS NULL;

-- 3. Business Logic: Negative Financials
-- Expectation: 0 rows (Unless adjustments are tracked, but usually raw sales shouldn't be negative in this schema)
SELECT count(*) as negative_trans_count
FROM fact_credit_card_metrics
WHERE total_trans_amt < 0 
   OR credit_limit < 0;

-- 4. Referential Integrity: Orphaned Facts
-- Expectation: 0 rows (All facts must link to a valid customer)
SELECT count(*) as orphaned_records
FROM fact_credit_card_metrics f
LEFT JOIN dim_customer c ON f.client_id = c.client_id
WHERE c.client_id IS NULL;

-- 5. Distribution Check: Valid States
-- Expectation: Ensure state codes are valid length (2 chars)
SELECT DISTINCT state_code
FROM dim_customer
WHERE LENGTH(state_code) != 2;

-- 6. Outlier Detection: Utilization Ratio > 1 (100%)
-- Expectation: Low count (Some over-limit is possible, but high numbers indicate data issues)
SELECT count(*) as over_limit_count
FROM fact_credit_card_metrics
WHERE utilization_ratio > 1.0;
