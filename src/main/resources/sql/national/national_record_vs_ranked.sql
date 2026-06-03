-- team records vs ranked teams for a given year

select 
    row_number() over (order by t.Pct desc) as '#',
	t.teamid as 'TeamId',
	t.Team as Team,
	t.G as Games,
    t.Wins as Wins,
    t.Losses as Losses,
    t.Points as 'Points Scored',
    t.PointsAllowed as 'Points Allowed',
    t.Point_Diff_G as 'Point Diff/G',
    t.Pct as Pct
from    
(select 
	team.teamid as 'TeamId',
	team.name as Team,
	(records.won + records.lost) as G,
    records.won as Wins,
    records.lost as Losses,
    records.Pct as Pct,
    records.Points as Points,
    records.PointsAllowed as 'PointsAllowed',
    round((records.Points - records.PointsAllowed) / (records.won + records.lost), 2) as 'Point_Diff_G'
from (
SELECT team, SUM(t1.Win) As Won, SUM(t1.Loss) as Lost, SUM(t1.Win) / (SUM(t1.Loss) + SUM(t1.Win)) as Pct, SUM(t1.Points) as Points, SUM(t1.PointsAllowed) as 'PointsAllowed'
FROM
( SELECT game.hometeamid as team, 
     CASE WHEN game.hometeamid = game.winnerteamid THEN 1 ELSE 0 END as Win, 
     CASE WHEN game.hometeamid <> game.winnerteamid THEN 1 ELSE 0 END as Loss,
     game.homescore as 'Points',
     game.awayscore as 'PointsAllowed'
  FROM game
  where
		(game.awayteamrank > 0 and game.awayteamrank <= 25) and
        game.year = :year
  UNION ALL
  SELECT game.awayteamid as team,
     CASE WHEN game.awayteamid = game.winnerteamid THEN 1 ELSE 0 END as Win, 
     CASE WHEN game.awayteamid <> game.winnerteamid THEN 1 ELSE 0 END as Loss,
     game.awayscore as 'Points',
     game.homescore as 'PointsAllowed'
  FROM game
  where
		(game.hometeamrank > 0 and game.hometeamrank <= 25) and
        game.year = :year
) as t1
GROUP BY 
	team
) as records
join team on team.teamid = records.team
join conference on conference.conferenceid = team.conferenceid
where
	conference.division = 'FBS' 
) as t
