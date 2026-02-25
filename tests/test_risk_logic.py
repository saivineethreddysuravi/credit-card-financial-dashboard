import pytest
import pandas as pd
from scripts.data_cleaning import clean_customer_data

def test_risk_tier_assignment():
    """Test that risk tiers are correctly assigned based on credit scores."""
    sample_data = pd.DataFrame({
        'customer_id': [1, 2, 3],
        'credit_score': [800, 700, 500]
    })
    
    cleaned_df = clean_customer_data(sample_data)
    
    assert cleaned_df.loc[cleaned_df['customer_id'] == 1, 'risk_tier'].values[0] == 'Low Risk'
    assert cleaned_df.loc[cleaned_df['customer_id'] == 2, 'risk_tier'].values[0] == 'Medium Risk'
    assert cleaned_df.loc[cleaned_df['customer_id'] == 3, 'risk_tier'].values[0] == 'High Risk'

def test_income_standardization():
    """Test that income is correctly cast to numeric values."""
    sample_data = pd.DataFrame({
        'customer_id': [4],
        'annual_income': ['75000'],
        'credit_score': [720]
    })
    
    cleaned_df = clean_customer_data(sample_data)
    assert pd.api.types.is_numeric_dtype(cleaned_df['annual_income'])
    assert cleaned_df['annual_income'].values[0] == 75000
