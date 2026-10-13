# PLAYBOOK — Power BI DAX Measures

Verified values from the fullstack export on 2026-10-13.

| Measure | DAX | Value |
|---|---|---|
| Total Matches | `Total Matches := COUNTROWS(Fact_Match)` | 50 |
| Completed Matches | `Completed := CALCULATE([Total Matches], Fact_Match[Status] IN {"verified","completed"})` | 20 |
| Completion % | `Completion % := DIVIDE([Completed Matches], [Total Matches])` | 40% |
| Avg Score | `Avg Score := AVERAGE(Fact_Match[TotalPoints])` | 99.0 |
| Avg Margin | `Avg Margin := AVERAGE(Fact_Match[Margin])` | 6.3 |
| Total Players | `Total Players := COUNTROWS(Dim_Player)` | 290 |
| Total Events | `Total Events := COUNTROWS(Fact_Event)` | 466 |
| Live Matches | `Live := CALCULATE([Total Matches], Fact_Match[Status] = "live")` | 5 |

## Star schema
- Fact_Match (50 rows) — in `data/Fact_Match.csv`
- Fact_Event (466 rows) — full export from the live database, see README
- Dim_Team (27 rows) — in `data/Dim_Team.csv`
- Dim_Player (290 rows) — full export from the live database, see README
- Dim_Venue (8 rows) — in `data/Dim_Venue.csv`
- Dim_Tournament (4 rows) — in `data/Dim_Tournament.csv`

Import the CSVs in Power BI Desktop via Get Data → Text/CSV, relate
Fact_Match[TournamentKey] → Dim_Tournament, Fact_Match[VenueKey] → Dim_Venue,
and team keys → Dim_Team, then add the measures above.
