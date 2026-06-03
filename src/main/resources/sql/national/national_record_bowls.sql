-- all time (since 2001) BOWL GAME win/loss, pct results
select 
    row_number() over (order by t.Pct desc) as '#',
    t.TeamId,
    t.Team,
    t.Wins,
    t.Losses,
    t.Pct
from
(select 
	team.teamid as TeamId,
	team.name as Team,
    records.won as Wins,
    records.lost as Losses,
    records.Pct as Pct
from (
SELECT team, SUM(t.Win) As Won, SUM(t.Loss) as Lost, SUM(t.Win) / (SUM(t.Loss) + SUM(t.Win)) as Pct
FROM
( SELECT game.hometeamid as team, 
     CASE WHEN game.hometeamid = game.winnerteamid THEN 1 ELSE 0 END as Win, 
     CASE WHEN game.hometeamid <> game.winnerteamid THEN 1 ELSE 0 END as Loss
  FROM game
  WHERE game.bowl <> ''
  UNION ALL
  SELECT game.awayteamid as team,
     CASE WHEN game.awayteamid = game.winnerteamid THEN 1 ELSE 0 END as Win, 
     CASE WHEN game.awayteamid <> game.winnerteamid THEN 1 ELSE 0 END as Loss
  FROM game
  WHERE game.bowl <> ''
) t
GROUP BY 
	team
) as records
join team on team.teamid = records.team
join conference on conference.conferenceid = team.conferenceid
where
	conference.division = 'FBS'
) as t
