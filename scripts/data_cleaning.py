import pandas as pd
import numpy as np

def clean_customer_data(df):
    """
    Cleans customer data, standardizes income, and assigns risk tiers.
    """
    df = df.copy()
    
    # Standardize income
    if 'annual_income' in df.columns:
        df['annual_income'] = pd.to_numeric(df['annual_income'], errors='coerce')
        df['annual_income'] = df['annual_income'].fillna(df['annual_income'].mean())
    
    # Assign risk tiers based on credit score
    if 'credit_score' in df.columns:
        conditions = [
            (df['credit_score'] >= 750),
            (df['credit_score'] >= 650) & (df['credit_score'] < 750),
            (df['credit_score'] < 650)
        ]
        choices = ['Low Risk', 'Medium Risk', 'High Risk']
        df['risk_tier'] = np.select(conditions, choices, default='High Risk')
        
    return df
