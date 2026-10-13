-- PLAYBOOK — SQL Data Layer
-- Relational schema: organizations -> tournaments -> teams/players,
-- venues, matches, match_events, audit_logs, notifications, settings.
-- SQLite dialect (as used in the fullstack build). For PostgreSQL, replace
-- INTEGER PRIMARY KEY AUTOINCREMENT with SERIAL PRIMARY KEY and INTEGER
-- timestamps with TIMESTAMPTZ. Standings are never stored — they are
-- computed server-side with the aggregation in queries.sql.

CREATE TABLE organizations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'Corporate',
  city TEXT NOT NULL DEFAULT '',
  contact_email TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL
);

CREATE TABLE sports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  icon TEXT NOT NULL DEFAULT '🏆',
  players_per_side INTEGER NOT NULL DEFAULT 11,
  squad_size INTEGER NOT NULL DEFAULT 15,
  scoring_unit TEXT NOT NULL DEFAULT 'point',
  score_label TEXT NOT NULL DEFAULT 'Points',
  period_label TEXT NOT NULL DEFAULT 'Half',
  periods INTEGER NOT NULL DEFAULT 2,
  match_duration_mins INTEGER NOT NULL DEFAULT 90,
  points_win INTEGER NOT NULL DEFAULT 3,
  points_draw INTEGER NOT NULL DEFAULT 1,
  points_loss INTEGER NOT NULL DEFAULT 0,
  allow_draw INTEGER NOT NULL DEFAULT 1,
  stat_keys TEXT NOT NULL DEFAULT '[]',
  event_types TEXT NOT NULL DEFAULT '[]'
);

CREATE TABLE tournaments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  org_id INTEGER NOT NULL REFERENCES organizations(id),
  sport_id INTEGER NOT NULL REFERENCES sports(id),
  name TEXT NOT NULL,
  format TEXT NOT NULL DEFAULT 'league',
  status TEXT NOT NULL DEFAULT 'draft',
  start_date TEXT NOT NULL DEFAULT '',
  end_date TEXT NOT NULL DEFAULT '',
  reg_deadline TEXT NOT NULL DEFAULT '',
  location TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  rules TEXT NOT NULL DEFAULT '',
  verification_levels INTEGER NOT NULL DEFAULT 2,
  is_public INTEGER NOT NULL DEFAULT 1,
  created_at INTEGER NOT NULL
);

CREATE TABLE venues (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  address TEXT NOT NULL DEFAULT '',
  city TEXT NOT NULL DEFAULT '',
  capacity INTEGER NOT NULL DEFAULT 0,
  sport_id INTEGER REFERENCES sports(id),
  surface TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL
);

CREATE TABLE teams (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tournament_id INTEGER NOT NULL REFERENCES tournaments(id),
  org_id INTEGER REFERENCES organizations(id),
  name TEXT NOT NULL,
  short_name TEXT NOT NULL DEFAULT '',
  group_name TEXT NOT NULL DEFAULT '',
  captain_name TEXT NOT NULL DEFAULT '',
  manager_name TEXT NOT NULL DEFAULT '',
  color TEXT NOT NULL DEFAULT '#2E7CF6',
  created_at INTEGER NOT NULL
);

CREATE TABLE players (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  team_id INTEGER NOT NULL REFERENCES teams(id),
  name TEXT NOT NULL,
  position TEXT NOT NULL DEFAULT '',
  jersey INTEGER NOT NULL DEFAULT 0,
  department TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL
);

CREATE TABLE matches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tournament_id INTEGER NOT NULL REFERENCES tournaments(id),
  code TEXT NOT NULL DEFAULT '',
  stage TEXT NOT NULL DEFAULT 'League',
  round INTEGER NOT NULL DEFAULT 1,
  team_a_id INTEGER NOT NULL REFERENCES teams(id),
  team_b_id INTEGER NOT NULL REFERENCES teams(id),
  venue_id INTEGER REFERENCES venues(id),
  scheduled_at TEXT NOT NULL DEFAULT '',
  status TEXT NOT NULL DEFAULT 'scheduled',
  score_a INTEGER NOT NULL DEFAULT 0,
  score_b INTEGER NOT NULL DEFAULT 0,
  minute INTEGER NOT NULL DEFAULT 0,
  period INTEGER NOT NULL DEFAULT 1,
  referee TEXT NOT NULL DEFAULT '',
  scorer TEXT NOT NULL DEFAULT '',
  winner_team_id INTEGER,
  verified_by TEXT NOT NULL DEFAULT '',
  delay_mins INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL
);

CREATE TABLE match_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  match_id INTEGER NOT NULL REFERENCES matches(id),
  team_id INTEGER,
  player_id INTEGER,
  type TEXT NOT NULL,
  label TEXT NOT NULL DEFAULT '',
  minute INTEGER NOT NULL DEFAULT 0,
  points INTEGER NOT NULL DEFAULT 0,
  idempotency_key TEXT NOT NULL UNIQUE,
  created_at INTEGER NOT NULL
);

CREATE TABLE audit_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  actor TEXT NOT NULL DEFAULT 'Admin',
  role TEXT NOT NULL DEFAULT 'super_admin',
  action TEXT NOT NULL,
  entity TEXT NOT NULL DEFAULT '',
  entity_id INTEGER,
  detail TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL
);

CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  kind TEXT NOT NULL DEFAULT 'info',
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  is_read INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL
);

CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

CREATE TABLE player_ratings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  player_id INTEGER NOT NULL REFERENCES players(id),
  tournament_id INTEGER NOT NULL REFERENCES tournaments(id),
  rating REAL NOT NULL DEFAULT 0,
  form_score REAL NOT NULL DEFAULT 0,
  computed_at INTEGER NOT NULL
);

CREATE INDEX idx_matches_tournament ON matches(tournament_id);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_teams_tournament ON teams(tournament_id);
CREATE INDEX idx_players_team ON players(team_id);
CREATE INDEX idx_events_match ON match_events(match_id);
