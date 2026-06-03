-- Team total yards offense and defense for a season
select
	"Offense" as "Team",
	teamoffense.* 
from
(select 
	team.teamid,
    row_number() over (order by ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / COUNT(DISTINCT game.gameid), 2) desc) as "#",
    COUNT(DISTINCT game.gameid) AS Games,
    SUM(tgs.rushyards) as "Rush Yards",
    SUM(tgs.passyards) as "Pass Yards",
    SUM(tgs.rushatts) + SUM(tgs.passatts) as Plays,
    SUM(tgs.rushyards) + SUM(tgs.passyards) as "Total Yards",
	ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / (SUM(tgs.rushatts) + SUM(tgs.passatts)), 2) as "Yards/Play",
	ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / COUNT(DISTINCT game.gameid), 2) as "Yards/Game"
FROM
    teamgamestat as tgs
    JOIN team ON team.teamid = tgs.teamid
    JOIN game ON game.gameid = tgs.gameid
    JOIN conference ON conference.conferenceid = team.conferenceid
    WHERE
        game.year = :year AND 
        conference.division = 'FBS'
    GROUP BY team.teamid
) AS teamoffense
where teamoffense.teamid = :teamid
UNION
-- Total Team Defense
select
	"Defense" as "Team",
	teamdefense.*
from
(select 
	team1.teamid,
	row_number() over (order by round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / count(distinct game.gameid), 2) asc) as "#",
	count(distinct game.gameid) as Games,
	sum(tgs2.rushyards) as "Rush Yards",
	sum(tgs2.passyards) as "Pass Yards",
	sum(tgs2.rushatts) + sum(tgs2.passatts) as Plays, 
	sum(tgs2.rushyards) + sum(tgs2.passyards) as "Total Yards",
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / (sum(tgs2.rushatts) + sum(tgs2.passatts)), 2) as "Yards/Play",
    round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / count(distinct game.gameid), 2) as "Yards/Game"
from teamgamestat AS tgs1 
    JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
    JOIN game as game ON tgs1.gameid = game.gameid
    JOIN team as team1 on team1.teamid = tgs1.teamid
    join conference as conference on conference.conferenceid = team1.conferenceid
where
	game.year = :year and
    conference.division = 'FBS'
group by
	team1.teamid
) as teamdefense
where
	teamdefense.teamid = :teamid
