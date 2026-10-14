# PLAYBOOK — Power BI: open and publish guide

This folder is a complete **Power BI Project (PBIP)**:

- `PLAYBOOK.pbip` — the project file you open
- `PLAYBOOK.SemanticModel/` — the dataset (model.bim): 4 tables loaded from the
  CSVs in `data/`, relationships, and all DAX measures on Fact_Match
- `PLAYBOOK.Report/` — the 3-page report (Overview, Standings & Results,
  Insights) in the new PBIR format, with KPI cards, a pie chart, bar and
  column charts, a line chart, a results table and slicers
- `data/` — Fact_Match (50), Dim_Team (27), Dim_Venue (8), Dim_Tournament (4)

## 1. Install Power BI Desktop (free)

Install **Power BI Desktop** from the Microsoft Store (free). It is a
Windows app.

## 2. Open the project

1. Double-click `PLAYBOOK.pbip` (or open it from Power BI Desktop:
   File > Open). Opening a .pbip file needs the PBIP preview feature:
   File > Options and settings > Options > Preview features >
   "Power BI Project (.pbip) save option" — turn it on and restart if asked.
2. If Power BI prompts for the **DataFolder** parameter, set it to the
   **full path of this repo's `powerbi/data` folder**
   (for example `C:\Users\<you>\playbook_spolto\powerbi\data`).
   The model stores each table as a Power Query query that reads
   `DataFolder & "\<Table>.csv"`, so the parameter is the only path it needs.
3. Click **Refresh** (Home ribbon). All four tables should load:
   50 matches, 27 teams, 8 venues, 4 tournaments.
4. Check the three report pages: **Overview** (KPI cards: 50 total matches,
   5 live, 290 players, 40% completion; pie of matches by status; matches by
   sport; matches-by-date line; tournament and sport slicers),
   **Standings & Results** (matches by venue, Avg Margin card, match results
   table) and **Insights** (matches by tournament, matches by city, Total
   Events 466, Verified Results).

## 3. Publish to your Power BI account

1. Sign in to Power BI Desktop with your Microsoft / Power BI account
   (top-right). A free account is created at app.powerbi.com if needed.
2. Home > **Publish** > choose **My workspace** > Select.
3. Open app.powerbi.com — the PLAYBOOK dataset and report appear in
   My workspace. Open the report to use it in the browser.

## 4. Optional: public link

In the Power BI service, open the report > File > Embed report >
**Publish to web (public)** and copy the link. Anyone with the link can
view the dashboard (the data is a public demo dataset, nothing private).
Note: Publish to web can be disabled on some tenant types; if the option
is missing, the workspace link from step 3 still works for signed-in users.

## Fallback if Desktop shows a repair prompt

PBIP/PBIR is a preview format; if your Desktop build asks to repair or
upgrade anything, you can rebuild the same thing manually in minutes:

1. New report > Get Data > Text/CSV and import the 4 CSVs from `data/`.
2. In Model view, create the relationships: Fact_Match.TeamAKey and
   Fact_Match.TeamBKey to Dim_Team.TeamKey, Fact_Match.VenueKey to
   Dim_Venue.VenueKey, Fact_Match.TournamentKey to
   Dim_Tournament.TournamentKey.
3. Paste the measures from `DAX_measures.md` (New measure on Fact_Match).
4. Rebuild the visuals from the tables and measures — the layout above
   describes every chart on the three pages.
