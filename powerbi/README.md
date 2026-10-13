# Power BI Reporting Layer

Slicer dashboards (sport, tournament, venue, status) cross-filter the
visuals in the web app. This folder holds the star-schema dataset that
Power BI Desktop consumes directly.

- `data/Fact_Match.csv` — 50 matches (exact export, verified 2026-10-13)
- `data/Dim_Team.csv` — 27 teams
- `data/Dim_Venue.csv` — 8 venues
- `data/Dim_Tournament.csv` — 4 tournaments
- `DAX_measures.md` — all DAX measures with their verified values

Fact_Event (466 rows) and Dim_Player (290 rows) are generated from the
live fullstack database via its `getPowerBiDataset` action — they are
described in `DAX_measures.md` and consumed by `python/player_ratings.py`
when placed in `data/`.
