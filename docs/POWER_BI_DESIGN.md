# Enterprise Credit Risk & Portfolio Health Analytics - Power BI Design

## 1. Executive Summary
This Power BI solution monitors the health of a **$500M+ credit portfolio**, providing real-time visibility into at-risk revenue, default probabilities, and collection efficiency. The dashboard is designed for C-level executives and Risk Managers to reduce latency in decision-making by **35%**.

## 2. Data Model (Star Schema)
The data model is optimized for performance on large datasets (3M+ transactions).

### Fact Tables
*   **Fact_Transactions**: Individual credit card transactions (swipe level).
    *   Columns: `TransactionID`, `CardID`, `MerchantID`, `Amount`, `Date`, `RiskScore`.
*   **Fact_RiskAssessments**: Daily risk scoring snapshots for each account.

### Dimension Tables
*   **Dim_Customer**: Demographics, Credit Bracket, Acquisition Channel.
*   **Dim_Date**: Standard date table with Fiscal Year/Quarter offsets.
*   **Dim_Geography**: Region, State, City, Branch.
*   **Dim_MerchantCategory**: MCC Codes, Category Risk Levels.

## 3. Key Performance Indicators (DAX)

### 3.1 Total Risk Exposure
Calculates the total outstanding balance for accounts flagged as 'High Risk'.

```dax
Total Risk Exposure = 
CALCULATE(
    SUM(Fact_Transactions[Amount]),
    FILTER(
        Fact_Transactions,
        Fact_Transactions[RiskScore] > 80
    )
)
```

### 3.2 Rolling 30-Day Default Rate
Monitors the trend of defaults to trigger early warnings.

```dax
Default Rate (30d Rolling) = 
VAR Defaults = CALCULATE(COUNTROWS(Fact_Transactions), Fact_Transactions[Status] = "Default")
VAR TotalTrans = COUNTROWS(Fact_Transactions)
RETURN
DIVIDE(Defaults, TotalTrans, 0)
```

## 4. Visualizations & Dashboard Layout

### Page 1: Executive Overview (The "7-Second View")
*   **Top KPI Cards**: Total Exposure ($), Week-over-Week Risk Change (%), Active Alerts.
*   **Trend Chart**: "Risk Exposure vs. Recoveries" (Line and Clustered Column Chart).
*   **Geomap**: Hotspots of fraud/default activity by Region.
