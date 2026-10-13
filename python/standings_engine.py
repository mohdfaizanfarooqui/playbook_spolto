"""PLAYBOOK — standings_engine.py
Recomputes the league table from verified/completed results in
powerbi/data/Fact_Match.csv using pandas. Cross-checks the SQL Data Layer.
Verified output for Corporate Football Cup 2026 (tournament 1):
  1. CloudNine United — P3 W3 D0 L0, GD +5, 9 pts
  2. FinEdge Warriors — P3 W2 D1 L0, 7 pts
  3. TechM Titans — 6 pts, 4. DataWolves FC — 6 pts, 5. Pune Paltan — 4 pts
Run: python3 python/standings_engine.py [tournament_id]
"""
import sys
from pathlib import Path
import pandas as pd

DATA = Path(__file__).resolve().parent.parent / "powerbi" / "data"

def compute(tournament_id: int = 1) -> pd.DataFrame:
    matches = pd.read_csv(DATA / "Fact_Match.csv")
    teams = pd.read_csv(DATA / "Dim_Team.csv")
    teams = teams[teams["TournamentKey"] == tournament_id]
    done = matches[(matches["TournamentKey"] == tournament_id) & (matches["Status"].isin(["verified", "completed"]))]
    rows = []
    for _, t in teams.iterrows():
        tid, name = t["TeamKey"], t["TeamName"]
        home = done[done["TeamAKey"] == tid]; away = done[done["TeamBKey"] == tid]
        scored = int(home["ScoreA"].sum() + away["ScoreB"].sum())
        conceded = int(home["ScoreB"].sum() + away["ScoreA"].sum())
        won = int(((home["ScoreA"] > home["ScoreB"]).sum()) + ((away["ScoreB"] > away["ScoreA"]).sum()))
        lost = int(((home["ScoreA"] < home["ScoreB"]).sum()) + ((away["ScoreB"] < away["ScoreA"]).sum()))
        played = int(len(home) + len(away)); drawn = played - won - lost
        rows.append({"Team": name, "P": played, "W": won, "D": drawn, "L": lost, "GF": scored, "GA": conceded, "GD": scored-conceded, "Pts": won*3+drawn})
    table = pd.DataFrame(rows).sort_values(["Pts","GD","GF","Team"], ascending=[False,False,False,True]).reset_index(drop=True)
    table.index += 1; table.index.name = "#"
    return table

if __name__ == "__main__":
    tid = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    print(compute(tid).to_string())
