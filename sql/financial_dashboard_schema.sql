-- ==============================================================================
-- Full Stack Data Analytics Project: Credit Card Financial Dashboard
-- Database Initialization & Data Pipeline Script
-- ==============================================================================
-- 
-- Architecture:
-- 1. STAGING LAYER: Raw data ingestion (VARCHAR/TEXT types to handle any format)
-- 2. TRANSFORMATION LAYER: Cleaning, Casting, and Normalizing data
-- 3. PRODUCTION LAYER: Final, typed tables (fact_credit_card, dim_customer) ready for BI
-- ==============================================================================

-- 1. CREATE DATABASE (Execute this separately if needed)
-- CREATE DATABASE credit_card_db;

-- ==============================================================================
-- STEP 1: STAGING TABLES (Raw Data)
-- ==============================================================================

DROP TABLE IF EXISTS staging_credit_card;
CREATE TABLE staging_credit_card (
    Client_Num VARCHAR(50),
    Card_Category VARCHAR(50),
    Annual_Fees VARCHAR(50),
    Activation_30_Days VARCHAR(50),
    Customer_Acq_Cost VARCHAR(50),
    Week_Start_Date VARCHAR(50), -- Raw date format 'DD-MM-YYYY'
    Week_Num VARCHAR(50),
    Qtr VARCHAR(50),
    current_year VARCHAR(50),
    Credit_Limit VARCHAR(50),
    Total_Revolving_Bal VARCHAR(50),
    Total_Trans_Amt VARCHAR(50),
    Total_Trans_Vol VARCHAR(50),
    Avg_Utilization_Ratio VARCHAR(50),
    Use_Chip VARCHAR(50),
    Exp_Type VARCHAR(50),
    Interest_Earned VARCHAR(50),
    Delinquent_Acc VARCHAR(50)
);

DROP TABLE IF EXISTS staging_customer;
CREATE TABLE staging_customer (
    Client_Num VARCHAR(50),
    Customer_Age VARCHAR(50),
    Gender VARCHAR(50),
    Dependent_Count VARCHAR(50),
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(50),
    state_cd VARCHAR(50),
    Zipcode VARCHAR(50),
    Car_Owner VARCHAR(50),
    House_Owner VARCHAR(50),
    Personal_loan VARCHAR(50),
    contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income VARCHAR(50),
    Cust_Satisfaction_Score VARCHAR(50)
);

-- ==============================================================================
-- STEP 2: COPY DATA TO STAGING (Simulated "Extract" Phase)
-- ==============================================================================
-- Note: Update paths to your local absolute paths
-- COPY staging_credit_card FROM '/path/to/data/credit_card.csv' DELIMITER ',' CSV HEADER;
-- COPY staging_customer FROM '/path/to/data/customer.csv' DELIMITER ',' CSV HEADER;


-- ==============================================================================
-- STEP 3: PRODUCTION TABLES (Cleaned Schema)
-- ==============================================================================

DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer (
    client_id INT PRIMARY KEY,
    age INT,
    gender CHAR(1),
    education_level VARCHAR(50),
    marital_status VARCHAR(50),
    income_segment VARCHAR(50),
    job_type VARCHAR(50),
    has_car BOOLEAN,
    has_house BOOLEAN,
    satisfaction_score INT,
    state_code CHAR(2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS fact_credit_card_metrics;
CREATE TABLE fact_credit_card_metrics (
    transaction_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES dim_customer(client_id),
    week_start_date DATE,
    quarter VARCHAR(10),
    card_type VARCHAR(20),
    credit_limit DECIMAL(10,2),
    total_revolving_bal DECIMAL(10,2),
    total_trans_amt DECIMAL(10,2),
    total_trans_vol INT,
    utilization_ratio DECIMAL(5,4),
    use_chip_method VARCHAR(20),
    expenditure_type VARCHAR(50),
    annual_fees DECIMAL(10,2),
    interest_earned DECIMAL(10,2),
    is_delinquent BOOLEAN
);

-- ==============================================================================
-- STEP 4: TRANSFORMATION PIPELINE (The "Messy to Clean" Logic)
-- ==============================================================================

-- 4.1 Clean & Load Customer Data
INSERT INTO dim_customer (
    client_id, age, gender, education_level, marital_status, 
    income_segment, job_type, has_car, has_house, satisfaction_score, state_code
)
SELECT 
    CAST(Client_Num AS INT),
    CAST(Customer_Age AS INT),
    Gender,
    -- Cleaning: Handle 'Unknown' or typos in Education
    CASE 
        WHEN Education_Level = 'Unknown' THEN 'Not Specified'
        ELSE Education_Level 
    END,
    Marital_Status,
    -- Cleaning: Standardize Income formats if needed (assuming clean here, but good practice)
    Income,
    -- Cleaning: Fix typos in Job titles (e.g., 'Selfemployeed' -> 'Self-Employed')
    CASE 
        WHEN Customer_Job = 'Selfemployeed' THEN 'Self-Employed'
        ELSE Customer_Job 
    END,
    -- Cleaning: Convert 'yes'/'no' to Boolean
    CASE WHEN Car_Owner = 'yes' THEN TRUE ELSE FALSE END,
    CASE WHEN House_Owner = 'yes' THEN TRUE ELSE FALSE END,
    CAST(Cust_Satisfaction_Score AS INT),
    state_cd
FROM staging_customer;

-- 4.2 Clean & Load Credit Card Fact Data
INSERT INTO fact_credit_card_metrics (
    client_id, week_start_date, quarter, card_type, 
    credit_limit, total_revolving_bal, total_trans_amt, total_trans_vol, 
    utilization_ratio, use_chip_method, expenditure_type, 
    annual_fees, interest_earned, is_delinquent
)
SELECT 
    CAST(Client_Num AS INT),
    -- Cleaning: Convert DD-MM-YYYY to YYYY-MM-DD Date Object
    TO_DATE(Week_Start_Date, 'DD-MM-YYYY'),
    Qtr,
    Card_Category,
    CAST(Credit_Limit AS DECIMAL(10,2)),
    CAST(Total_Revolving_Bal AS DECIMAL(10,2)),
    CAST(Total_Trans_Amt AS DECIMAL(10,2)),
    CAST(Total_Trans_Vol AS INT),
    CAST(Avg_Utilization_Ratio AS DECIMAL(5,4)),
    -- Cleaning: Trim whitespace from methods ('Chip ' -> 'Chip')
    TRIM(Use_Chip),
    Exp_Type,
    CAST(Annual_Fees AS DECIMAL(10,2)),
    CAST(Interest_Earned AS DECIMAL(10,2)),
    -- Cleaning: Convert 0/1 integers to Boolean
    CASE WHEN CAST(Delinquent_Acc AS INT) = 1 THEN TRUE ELSE FALSE END
FROM staging_credit_card;

-- ==============================================================================
-- End of Pipeline
-- ==============================================================================
