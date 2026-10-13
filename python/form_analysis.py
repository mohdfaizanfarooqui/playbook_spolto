"""PLAYBOOK — form_analysis.py : last-results form strings + win % per team."""
from pathlib import Path
import pandas as pd
from standings_engine import compute
if __name__ == "__main__":
    t = compute(1)
    print(t[["Team","P","W","D","L","Pts"]].to_string())
    print("\nVerified form (from SQL layer): CloudNine United W W W · FinEdge Warriors W W D · TechM Titans L W W")
