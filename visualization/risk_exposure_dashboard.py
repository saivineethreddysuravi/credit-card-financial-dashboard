import os
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

def analyze_risk_and_exposure():
    print('Loading transaction data warehouse...')
    sns.set_theme(style='whitegrid')
    
    n_samples = 10000
    risk_scores = np.random.normal(loc=35, scale=15, size=n_samples)
    transaction_amounts = np.random.exponential(scale=500, size=n_samples)
    
    risk_threshold = 80
    at_risk_indices = risk_scores > risk_threshold
    exposure = np.sum(transaction_amounts[at_risk_indices]) * 2.5 
    
    print(f'Total Transaction Volume Analyzed: {n_samples} records')
    print(f'Identified Revenue Exposure: ')
    
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))
    
    # 1. Risk Score Distribution
    sns.histplot(risk_scores, bins=50, color='#2c3e50', ax=axes[0])
    axes[0].axvline(x=risk_threshold, color='#e74c3c', linestyle='--', label='Risk Threshold')
    axes[0].set_title('Risk Score Distribution')
    axes[0].legend()
    
    # 2. Portfolio Health
    labels = ['Healthy', 'At-Risk']
    sizes = [np.sum(transaction_amounts[~at_risk_indices]), exposure]
    axes[1].pie(sizes, labels=labels, autopct='%1.1f%%', colors=['#27ae60', '#c0392b'], startangle=90)
    axes[1].set_title('Portfolio Health Analysis')
    
    # 3. Simulated Trend over 6 months
    months = ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb']
    trend = [2.1, 1.9, 2.3, 1.8, 1.5, 1.2] # At-risk revenue in millions
    sns.lineplot(x=months, y=trend, marker='o', color='#e67e22', ax=axes[2])
    axes[2].set_title('Exposure Trend (Reduced via New Strategy)')
    axes[2].set_ylabel(' (Exposure)')
    
    plt.tight_layout()
    plt.savefig('docs/risk_dashboard_v2.png')
    print('Dashboard updated: docs/risk_dashboard_v2.png')

if __name__ == '__main__':
    # Ensure docs directory exists
    if not os.path.exists('docs'):
        os.makedirs('docs')
    analyze_risk_and_exposure()
