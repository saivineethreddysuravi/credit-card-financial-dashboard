import pandas as pd

def calculate_data_quality_score(df):
    """
    Formulates a scoring model leveraging data risk factors.
    """
    completeness = df.notnull().mean().mean()
    accuracy = (df['Amount'] >= 0).mean()
    timeliness = 0.99
    
    weights = {'completeness': 0.3, 'accuracy': 0.4, 'timeliness': 0.3}
    final_score = (completeness * weights['completeness'] + 
                   accuracy * weights['accuracy'] + 
                   timeliness * weights['timeliness']) * 100
    
    print(f'--- Data Risk Assessment Report ---')
    print(f'Completeness: {completeness:.2%}')
    print(f'Accuracy: {accuracy:.2%}')
    print(f'Timeliness: {timeliness:.2%}')
    print(f'Final DQ Score: {final_score:.2f}/100')
    
    return final_score

if __name__ == '__main__':
    data = {'CustomerID': [1, 2, 3, 4, 5], 'Amount': [100, 250, -10, 300, 150], 'RiskScore': [0.1, 0.2, None, 0.15, 0.05]}
    df = pd.DataFrame(data)
    calculate_data_quality_score(df)
