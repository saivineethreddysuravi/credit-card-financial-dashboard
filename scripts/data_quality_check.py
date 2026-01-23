import pandas as pd
import os

def check_data_quality(data_dir="data"):
    """
    Checks for null values and data types in CSV files.
    """
    print("--- Starting Data Quality Check ---")
    
    if not os.path.exists(data_dir):
        print(f"Error: Directory {data_dir} not found.")
        return False

    files = [f for f in os.listdir(data_dir) if f.endswith('.csv')]
    
    overall_status = True
    
    for file in files:
        file_path = os.path.join(data_dir, file)
        print(f"\nChecking {file}...")
        
        try:
            df = pd.read_csv(file_path)
            
            # Check 1: Empty File
            if df.empty:
                print(f"❌ FAIL: File is empty.")
                overall_status = False
                continue
                
            # Check 2: Null Values
            null_counts = df.isnull().sum()
            total_nulls = null_counts.sum()
            
            if total_nulls > 0:
                print(f"⚠️ WARNING: Found {total_nulls} missing values.")
                print(null_counts[null_counts > 0])
            else:
                print("✅ PASS: No missing values.")
                
            # Check 3: Duplicate Rows
            dupes = df.duplicated().sum()
            if dupes > 0:
                print(f"⚠️ WARNING: Found {dupes} duplicate rows.")
            else:
                print("✅ PASS: No duplicates.")
                
        except Exception as e:
            print(f"❌ ERROR: Could not read file. {e}")
            overall_status = False
            
    if overall_status:
        print("\n--- DQ Check Completed Successfully ---")
        return True
    else:
        print("\n--- DQ Check Failed ---")
        return False

if __name__ == "__main__":
    # If run from root
    if os.path.exists("data"):
        check_data_quality("data")
    # If run from scripts/
    elif os.path.exists("../data"):
        check_data_quality("../data")
    else:
        print("Could not find data directory.")
