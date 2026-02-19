# Report-Level Data Risk Assessment Procedure

## 1. Identification of Data Risk Factors
To ensure the integrity of the Credit Risk Dashboard, the following risk factors are assessed at the report level:
- **Accuracy Risk:** Discrepancies between source (Snowflake) and report (Power BI).
- **Timeliness Risk:** Latency in daily transaction ETL pipelines.
- **Completeness Risk:** Missing values in critical fields (Customer ID, Transaction Amount).
- **Consistency Risk:** Variances in Risk Score calculation logic across different business units.

## 2. Risk Scoring Model (RSM)
A weighted scoring model is used to determine the overall Data Risk Level (1-5):
- **Accuracy (40%)**: (Actual Matches / Expected Matches) * 100
- **Timeliness (30%)**: (SLA Met / Total Runs) * 100
- **Completeness (30%)**: (Non-null Records / Total Records) * 100

**Formula:** `Total Risk Score = (A * 0.4) + (T * 0.3) + (C * 0.3)`

## 3. Measurement & Metrics
- **Leveraging existing metrics:** Automated DQ checks in Snowflake (SQL-based).
- **Tooling:** Integrated metadata tracking for lineage (aligned with Collibra standards).

## 4. Refinement Process
- Weekly design sprints to review assessment failures.
- Adjustment of risk weights based on business impact (e.g., higher weight on Accuracy during audit periods).
