"""PLAYBOOK — fixture_generator.py
Circle-method round-robin scheduler (pandas + itertools).
For the 8 core teams of Corporate Football Cup 2026 this produces
28 fixtures across 7 rounds — matching the fullstack build.
Run: python3 python/fixture_generator.py [tournament_id]
"""
import sys
from pathlib import Path
import pandas as pd

DATA = Path(__file__).resolve().parent.parent / "powerbi" / "data"

def generate(tournament_id: int = 1) -> pd.DataFrame:
    teams = pd.read_csv(DATA / "Dim_Team.csv")
    # Core league teams only (exclude the later-added 27th team, Burger Boys, key 27)
    names = teams[(teams["TournamentKey"] == tournament_id) & (teams["TeamKey"] <= 8)]["TeamName"].tolist()
    if len(names) % 2: names.append("BYE")
    n, rounds, fixtures = len(names), [], []
    arr = names[:]
    for r in range(1, n):
        for i in range(n // 2):
            a, b = arr[i], arr[n-1-i]
            if a != "BYE" and b != "BYE": fixtures.append({"Round": r, "Home": a, "Away": b})
        arr = [arr[0]] + [arr[-1]] + arr[1:-1]
    return pd.DataFrame(fixtures)

if __name__ == "__main__":
    tid = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    df = generate(tid); print(df.to_string(index=False)); print(f"\n{len(df)} fixtures across {df['Round'].nunique()} rounds")
