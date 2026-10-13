-- PLAYBOOK — SQL Insights
-- The standings query below is the exact query executed server-side in the
-- fullstack build for tournament 1 (Corporate Football Cup 2026).
-- Verified result on 2026-10-13: CloudNine United top — P3 W3 D0 L0, 9 pts, GD +5.

-- 1) League standings (win = 3, draw = 1)
SELECT t.id AS team_id, t.name AS team, t.short_name AS short, t.group_name AS grp,
  COUNT(m.id) AS played,
  SUM(CASE WHEN (m.team_a_id = t.id AND m.score_a > m.score_b) OR (m.team_b_id = t.id AND m.score_b > m.score_a) THEN 1 ELSE 0 END) AS won,
  SUM(CASE WHEN m.score_a = m.score_b THEN 1 ELSE 0 END) AS drawn,
  SUM(CASE WHEN (m.team_a_id = t.id AND m.score_a < m.score_b) OR (m.team_b_id = t.id AND m.score_b < m.score_a) THEN 1 ELSE 0 END) AS lost,
  SUM(CASE WHEN m.team_a_id = t.id THEN m.score_a ELSE m.score_b END) AS scored,
  SUM(CASE WHEN m.team_a_id = t.id THEN m.score_b ELSE m.score_a END) AS conceded,
  SUM(CASE WHEN m.team_a_id = t.id THEN m.score_a ELSE m.score_b END) - SUM(CASE WHEN m.team_a_id = t.id THEN m.score_b ELSE m.score_a END) AS diff,
  SUM(CASE WHEN (m.team_a_id = t.id AND m.score_a > m.score_b) OR (m.team_b_id = t.id AND m.score_b > m.score_a) THEN 3
           WHEN m.score_a = m.score_b THEN 1 ELSE 0 END) AS points
FROM teams t
LEFT JOIN matches m ON (m.team_a_id = t.id OR m.team_b_id = t.id)
  AND m.tournament_id = 1 AND m.status IN ('completed','verified')
WHERE t.tournament_id = 1
GROUP BY t.id
ORDER BY points DESC, diff DESC, scored DESC, team ASC;

-- 2) Top scorers (from match_events)
-- SELECT p.name AS player, t.name AS team, SUM(e.points) AS value
-- FROM match_events e
-- JOIN players p ON p.id = e.player_id
-- JOIN teams t ON t.id = e.team_id
-- WHERE e.type = 'score'
-- GROUP BY p.id ORDER BY value DESC LIMIT 10;
-- Verified leader: Ravi Kaur (Agile Avengers) — 135 points.

-- 3) Venue utilisation
-- SELECT v.name AS venue, COUNT(m.id) AS matches,
--        SUM(CASE WHEN m.status='live' THEN 1 ELSE 0 END) AS live
-- FROM venues v LEFT JOIN matches m ON m.venue_id = v.id
-- GROUP BY v.id ORDER BY matches DESC;
-- Verified busiest venue: MCA Ground — 15 matches.
