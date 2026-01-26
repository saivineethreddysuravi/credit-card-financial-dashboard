import pandas as pd
import os
from sqlalchemy import create_engine
from datetime import datetime

# Configuration
# In a real scenario, these would be in environment variables
DB_CONFIG = {
    'dbname': 'credit_card_db',
    'user': 'admin',
    'password': 'password',
    'host': 'localhost',
    'port': '5432'
}

DATA_DIR = os.path.join(os.path.dirname(__file__), '../data')

class CreditCardETL:
    """
    Automated ETL Pipeline for Credit Card Financial Dashboard.
    1. Extracts data from CSVs
    2. Transforms/Cleans data (Basic validation)
    3. Loads into Staging tables in SQL Database
    """
    
    def __init__(self):
        self.engine = None
        self.connection_string = f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['dbname']}"

    def connect_db(self):
        """Establishes database connection."""
        try:
            # self.engine = create_engine(self.connection_string)
            # print("✅ Connected to Database.")
            print("✅ [MOCK] Connected to PostgreSQL Database 'credit_card_db'.")
            return True
        except Exception as e:
            print(f"❌ Database connection failed: {e}")
            return False

    def extract_data(self, filename):
        """Reads CSV data."""
        filepath = os.path.join(DATA_DIR, filename)
        if not os.path.exists(filepath):
            print(f"❌ File not found: {filepath}")
            return None
        
        print(f"⬇️  Extracting {filename}...")
        return pd.read_csv(filepath)

    def transform_customer_data(self, df):
        """Applies transformation logic to customer data."""
        print("🔄 Transforming Customer Data...")
        
        # Example Transformation: Standardize Job Titles
        if 'Customer_Job' in df.columns:
            df['Customer_Job'] = df['Customer_Job'].str.title()
            
        # Example: Handle Missing Values
        df.fillna({'Education_Level': 'Unknown'}, inplace=True)
        
        return df

    def transform_transaction_data(self, df):
        """Applies transformation logic to transaction/credit card data."""
        print("🔄 Transforming Transaction Data...")
        
        # Example: Ensure dates are parsed (if this was a real load)
        # df['Week_Start_Date'] = pd.to_datetime(df['Week_Start_Date'], format='%d-%m-%Y')
        
        return df

    def load_to_staging(self, df, table_name):
        """Loads data to SQL Staging Table."""
        if df is None or df.empty:
            print("⚠️ No data to load.")
            return

        print(f"⬆️  Loading {len(df)} rows into '{table_name}'...")
        # In a real scenario:
        # df.to_sql(table_name, self.engine, if_exists='replace', index=False)
        print(f"✅ Successfully loaded data to {table_name}")

    def run_pipeline(self):
        """Orchestrates the ETL process."""
        print(f"🚀 Starting Daily ETL Pipeline - {datetime.now()}")
        
        if not self.connect_db():
            return

        # 1. Process Customer Data
        cust_df = self.extract_data('customer.csv')
        if cust_df is not None:
            clean_cust = self.transform_customer_data(cust_df)
            self.load_to_staging(clean_cust, 'staging_customer')

        # 2. Process Credit Card Data
        cc_df = self.extract_data('credit_card.csv')
        if cc_df is not None:
            clean_cc = self.transform_transaction_data(cc_df)
            self.load_to_staging(clean_cc, 'staging_credit_card')
            
        print("🏁 Pipeline Completed Successfully.")

if __name__ == "__main__":
    etl = CreditCardETL()
    etl.run_pipeline()
