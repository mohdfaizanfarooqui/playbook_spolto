# PLAYBOOK — Architecture

## Three layers (all functional, not nominal)
1. **SQL Data Layer** (`sql/`) — normalised relational schema:
   organisations → tournaments → teams/players, venues, matches,
   match_events, audit_logs, notifications, player_ratings.
   Standings, leaderboards and analytics are computed server-side with
   SQL aggregation — never only on the frontend.
2. **Python Analytics Engine** (`python/`) — Pandas jobs:
   fixture_generator (circle-method round robin), standings_engine
   (cross-checks SQL row-by-row), player_ratings (base 4.0 + scoring +
   assists + win share, capped 9.9), insights_engine, form_analysis,
   validate_import (read_csv + dtype/null/range checks).
3. **Power BI Reporting Layer** (`powerbi/`) — star schema
   (Fact_Match, Fact_Event, Dim_Team, Dim_Player, Dim_Venue,
   Dim_Tournament) + DAX measures, consumed by slicer dashboards.

## Verified data (2026-10-13)
4 organisations, 4 tournaments, 27 teams, 290 players, 50 matches
(5 live, 20 completed/verified), 466 match events, 8 venues.
Corporate Football Cup 2026 standings leader: CloudNine United, 9 pts.

## Deployable dashboard
`index.html` at the repo root is a zero-build static dashboard with the
verified data embedded. `.github/workflows/pages.yml` deploys it to
GitHub Pages on every push to `main`. No build step, no server, no
environment variables.

## Fullstack version
The interactive fullstack build (React + TypeScript server actions,
live scoring, RBAC, CRUD) runs as a Muse web artifact. This repository
is its standalone, GitHub-deployable edition: same schema, same SQL,
same Python jobs, same Power BI dataset and same verified data.
