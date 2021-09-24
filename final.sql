/*
This query uses a Subquery in the form of a Common Table Expression (CTE). The
CTE starts at Line 16 and ends at Line 36. The CTE contains a table which is
made up from the joining of multiple tables found in database.sqlite.

The CTE table has been filtered (Lines 34 - 35) to only return rows for the
Big 5 Leagues (England, France, Germany, Italy & Spain).

The final table creates a new column "country" using the SUBSTR function. Also,
the final table uses the SUBSTR function to create cleaner versions of the
"league" and "date" columns.

The final table is the database that will be exported as a csv file from within
the DB Browser software to be used as match data in a pandas DataFrame.
*/
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


/*
I will use the Player and Player_Attributes tables to incorporate some of the
FIFA game data (specifically overall rating and preferred_foot). I will now
create a JOINed table with the following columns:

• player_name
• birth_date
• height(INT)
• preferred_foot
• overall_rating
*/
SELECT pa.player_fifa_api_id AS fifa_id,
       pl.player_name AS player,
       pl.birthday AS birth_date,
       ROUND(pl.height, 0) AS height,
       pa.preferred_foot,
       pa.overall_rating AS rating
FROM Player pl
JOIN Player_Attributes pa
ON pl.player_fifa_api_id = pa.player_fifa_api_id;
