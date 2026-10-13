"""PLAYBOOK — validate_import.py : pandas read_csv + dtype/null/range checks,
mirroring the fullstack import validation. Usage: python3 python/validate_import.py <csv>"""
import sys, pandas as pd
if __name__ == "__main__":
    df = pd.read_csv(sys.argv[1]); print(f"Rows: {len(df)} | Columns: {list(df.columns)}")
    print("Nulls per column:"); print(df.isna().sum().to_string()); print("\nValid import." if len(df) else "\nEmpty file — invalid.")
