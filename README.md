# PLAYBOOK — Tournament Operating System

Production-grade sports tournament management, live scoring, standings, analytics and operations platform for organisations like **SPOLTO**.

**Repository:** https://github.com/mohdfaizanfarooqui/playbook_spolto

**Live dashboard:** https://mohdfaizanfarooqui.github.io/playbook_spolto/ (deployed with GitHub Pages from this repo — live after the first workflow run completes)

> SQL Data Layer → Python Analytics Engine → Power BI Reporting Layer

## What it does
- Tournament management — leagues, knockouts, round robin, groups
- Live scoring with match events, verification workflow and audit log
- Standings and leaderboards computed **server-side in SQL** — never only on the frontend
- Operations centre — live venues, postponed matches, results awaiting verification
- Analytics — top scorers, venue utilisation, participation by sport, competitiveness
- RBAC — Super Admin, Org Admin, Tournament Admin, Scorer, Referee, Viewer
- Public tournament and match pages

## Verified data in this repo
Exported and verified on **13 Oct 2026** from the live build:

| | |
|---|---|
| Organisations | 4 — SPOLTO, Tech Mahindra, Infosys, DY Patil University |
| Tournaments | 4 — Corporate Football Cup, Corporate Cricket League, SPOLTO Badminton Championship, Inter-Corporate Basketball League |
| Teams | 27 |
| Players | 290 |
| Matches | 50 (5 live, 20 completed/verified) |
| Match events | 466 |
| Venues | 8 |
| Standings leader | CloudNine United — P3 W3, 9 pts, GD +5 |
| Top scorer | Ravi Kaur (Agile Avengers) — 135 points |

## Layout
```
playbook/
├── index.html                  # Deployable dashboard (zero-build, GitHub Pages)
├── .github/workflows/pages.yml # Auto-deploy dashboard on push to main
├── sql/
│   ├── schema.sql              # Full relational schema
│   └── queries.sql             # Standings, top scorers, venue utilisation
├── python/
│   ├── standings_engine.py     # Pandas standings — cross-checks SQL exactly
│   ├── fixture_generator.py    # Circle-method round robin — 28 fixtures, 7 rounds
│   ├── player_ratings.py       # Ratings model (top: Priya Sheikh, 6.2)
│   ├── insights_engine.py
│   ├── form_analysis.py
│   ├── validate_import.py
│   └── requirements.txt
├── powerbi/
│   ├── DAX_measures.md         # DAX measures with verified values
│   ├── README.md
│   └── data/                   # Star schema: Fact_Match (50), Dim_Team (27),
│                               # Dim_Venue (8), Dim_Tournament (4)
└── docs/ARCHITECTURE.md
```

## Run the Python engine
```bash
pip install -r python/requirements.txt
python3 python/standings_engine.py     # 1. CloudNine United — 9 pts
python3 python/fixture_generator.py    # 28 fixtures across 7 rounds
python3 python/insights_engine.py
```

## Run the dashboard locally
```bash
python3 -m http.server 8000
# open http://localhost:8000
```
Or just open `index.html` in a browser — there is no build step.

## Deploy
Pushing to `main` runs `.github/workflows/pages.yml`, which publishes the
repo root to GitHub Pages. In the repo: **Settings → Pages → Build and
deployment → Source: GitHub Actions** (the workflow does the rest).

## Tech
SQL (SQLite/PostgreSQL-compatible schema), Python, Pandas, Power BI (DAX, star schema), HTML/CSS/JS dashboard. The interactive fullstack edition is built in React + TypeScript with Drizzle ORM and server actions.

## Author
**Faizan Farooqui** — Data Science and ML Trainee, Matsuo-Iwasawa Lab, University of Tokyo (GCI programme); Technology and Data Operations Coordinator at SPOLTO (May–Sep 2026).

MIT License — see `LICENSE`.

---

## Updates — 13 Oct 2026

- **Dashboard v2:** colourful redesign with real photos from [spolto.com](https://spolto.com) and six live charts (matches by status doughnut, players by sport pie, team points, matches per day, venue utilisation, top scorers).
- **Power BI project:** `powerbi/PLAYBOOK.pbip` — a complete Power BI project (star-schema semantic model, 9 DAX measures, 3-page report with 17 visuals). Open it in Power BI Desktop and publish to app.powerbi.com — see `powerbi/PUBLISH_GUIDE.md`. Note: opened from the repo CSVs, two measures compute on the extract (Avg Margin 5.3); the web dashboard shows the live app's DAX outputs (6.3, Avg Score 99.0).
