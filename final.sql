WITH big5 AS
(
  SELECT lg.name AS league,
         mt.season,
         mt.date,
         tm1.team_long_name AS home_team,
         tm2.team_long_name AS away_team,
         mt.home_team_goal,
         mt.away_team_goal,
         mt.shoton AS shots_on_goal,
         mt.possession
  FROM Match mt
  JOIN Team tm1
  ON tm1.team_api_id = mt.home_team_api_id
  JOIN Team tm2
  ON tm2.team_api_id = mt.away_team_api_id
  JOIN League lg
  ON lg.id = mt.league_id
  WHERE lg.name IN ("England Premier League", "France Ligue 1", "Germany 1. Bundesliga",
                    "Italy Serie A", "Spain LIGA BBVA")
)
SELECT SUBSTR(league, 1, INSTR(league, " ") - 1) AS country,
       league,
       SUBSTR(league, INSTR(league, " ")) AS clean_league,
       season,
       date,
       SUBSTR(date,1, 10) AS clean_date,
       home_team,
       away_team,
       home_team_goal,
       away_team_goal,
       shots_on_goal,
       possession
FROM big5;
