import matplotlib.pyplot as plt


from datetime import datetime, timedelta

def simulate_and_visualize_retention():
    print("Forecasting Revenue Retention...")
    
    # Simulate 12 months of data
    dates = [datetime.today() + timedelta(days=30*i) for i in range(12)]
    months = [d.strftime('%b %Y') for d in dates]
    
    # Simulate data
    base_revenue = 1200000 # $1.2M
    growth_rate = 0.05
    churn_rate_pre_intervention = 0.15
    churn_rate_post_intervention = 0.08
    
    revenue_pre = []
    revenue_post = []
    
    current_rev_pre = base_revenue
    current_rev_post = base_revenue
    
    for _ in range(12):
        # Pre-intervention simulation
        current_rev_pre = current_rev_pre * (1 + growth_rate - churn_rate_pre_intervention)
        revenue_pre.append(current_rev_pre)
        
        # Post-intervention simulation
        current_rev_post = current_rev_post * (1 + growth_rate - churn_rate_post_intervention)
        revenue_post.append(current_rev_post)

    # Calculate Retained Revenue
    total_retained = sum(revenue_post) - sum(revenue_pre)
    print(f"Projected Annual Retained Revenue: ${total_retained:,.2f}")

    # Visualization
    plt.figure(figsize=(12, 6))
    
    plt.plot(months, revenue_post, marker='o', linestyle='-', color='#27ae60', label='With Risk Intelligence (Projected)')
    plt.plot(months, revenue_pre, marker='x', linestyle='--', color='#c0392b', label='Baseline (Without Intervention)')
    
    plt.fill_between(months, revenue_pre, revenue_post, color='#27ae60', alpha=0.1, label='Retained Revenue Gap')
    
    plt.title('Revenue Retention Forecast: Impact of Credit Risk Model', fontsize=14)
    plt.ylabel('Monthly Revenue ($)', fontsize=12)
    plt.xlabel('Forecast Horizon', fontsize=12)
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.legend()
    plt.xticks(rotation=45)
    plt.tight_layout()
    
    output_file = 'revenue_retention_forecast.png'
    plt.savefig(output_file)
    print(f"Forecast chart generated: {output_file}")

if __name__ == "__main__":
    simulate_and_visualize_retention()
