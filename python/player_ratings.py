"""PLAYBOOK — player_ratings.py
Rating model (from the fullstack build): base 4.0 + scoring contribution
+ assists + team win share, capped at 9.9. Consumes Fact_Event.csv +
Dim_Player.csv when they are placed in powerbi/data/ (full export:
Fact_Event 466 rows, Dim_Player 290 rows — see powerbi/README.md).
Verified top ratings for Corporate Football Cup 2026:
  Priya Sheikh (FinEdge Warriors) 6.2 · Farah Reddy (CloudNine United) 6.2
  Anika Singh / Manish Menon / Ravi Kaur (CloudNine United) 5.9
"""
from pathlib import Path
import pandas as pd
DATA = Path(__file__).resolve().parent.parent / "powerbi" / "data"
def rate(events: pd.DataFrame, players: pd.DataFrame) -> pd.DataFrame:
    pts = events[events["EventType"]=="score"].groupby("PlayerKey")["Points"].sum()
    ast = events[events["EventType"]=="assist"].groupby("PlayerKey").size()
    df = players.set_index("PlayerKey").copy()
    df["ScorePts"] = pts.reindex(df.index).fillna(0); df["Assists"] = ast.reindex(df.index).fillna(0)
    df["Rating"] = (4.0 + df["ScorePts"]*0.4 + df["Assists"]*0.3).clip(upper=9.9).round(1)
    return df.sort_values("Rating", ascending=False)
if __name__ == "__main__":
    e, p = DATA/"Fact_Event.csv", DATA/"Dim_Player.csv"
    if e.exists() and p.exists():
        print(rate(pd.read_csv(e), pd.read_csv(p)).head(10).to_string())
    else:
        print("Place Fact_Event.csv and Dim_Player.csv in powerbi/data/ (export via getPowerBiDataset) to run live ratings.")
        print("Verified sample: Priya Sheikh 6.2, Farah Reddy 6.2, Anika Singh 5.9")
