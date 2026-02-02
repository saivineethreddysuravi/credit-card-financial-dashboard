# Data Dictionary

## Overview
This document outlines the schema for the **Enterprise Credit Risk & Portfolio Health Analytics** database. The data model follows a **Star Schema** architecture, optimized for analytical queries and reporting in Power BI.

---

## 1. Dimension Tables

### `dim_customer`
Stores descriptive attributes about the credit card holders. This table allows for slicing and dicing metrics by demographics.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `client_id` | `INT` (PK) | Unique identifier for each customer. |
| `age` | `INT` | Age of the customer in years. |
| `gender` | `CHAR(1)` | Gender of the customer (M/F). |
| `education_level` | `VARCHAR` | Highest level of education attained (e.g., Graduate, High School). |
| `marital_status` | `VARCHAR` | Marital status (e.g., Married, Single). |
| `income_segment` | `VARCHAR` | Annual income bracket (e.g., $40K - $60K). |
| `job_type` | `VARCHAR` | Employment category (e.g., Blue-collar, Self-employed). |
| `has_car` | `BOOLEAN` | Indicator if the customer owns a car. |
| `has_house` | `BOOLEAN` | Indicator if the customer owns a house. |
| `satisfaction_score`| `INT` | Customer satisfaction score (1-5 scale) from recent surveys. |
| `state_code` | `CHAR(2)` | Two-letter state abbreviation (USA). |
| `updated_at` | `TIMESTAMP` | Timestamp of when the record was last updated. |

---

## 2. Fact Tables

### `fact_credit_card_metrics`
Contains the quantitative transactional data and performance metrics for the credit cards. This is the central table for all financial aggregations.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `transaction_id` | `SERIAL` (PK)| Unique identifier for each transaction record. |
| `client_id` | `INT` (FK) | Foreign key linking to `dim_customer`. |
| `week_start_date` | `DATE` | The start date of the week for the aggregated metrics. |
| `quarter` | `VARCHAR` | Fiscal quarter (e.g., Q1, Q2). |
| `card_type` | `VARCHAR` | Tier of the credit card (e.g., Blue, Silver, Gold, Platinum). |
| `credit_limit` | `DECIMAL` | Total credit limit assigned to the card. |
| `total_revolving_bal`| `DECIMAL` | Unpaid balance carried over from the previous month. |
| `total_trans_amt` | `DECIMAL` | Total amount spent in transactions for the period. |
| `total_trans_vol` | `INT` | Total count of transactions for the period. |
| `utilization_ratio` | `DECIMAL` | Ratio of `total_revolving_bal` to `credit_limit`. |
| `use_chip_method` | `VARCHAR` | Method of transaction (e.g., Chip, Swipe, Online). |
| `expenditure_type` | `VARCHAR` | Category of spend (e.g., Bills, Entertainment, Grocery). |
| `annual_fees` | `DECIMAL` | Annual fee charged for the card. |
| `interest_earned` | `DECIMAL` | Interest revenue generated from revolving balances. |
| `is_delinquent` | `BOOLEAN` | Flag indicating if the account is past due on payments. |
