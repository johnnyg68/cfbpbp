-- Team total offense and defense
select
	"Offense" as "Team",
	teamoffense.*
from
(select 
	team.teamid,
	sum(tgs.points) / COUNT(DISTINCT game.gameid) as "Points/G",	
	round((sum(tgs.rushyards) + sum(tgs.passyards)) / COUNT(DISTINCT game.gameid), 2)  as "Yards/G",
	round((sum(tgs.rushyards) + sum(tgs.passyards)) / (sum(tgs.rushatts) + SUM(tgs.passatts)), 2) as "Yards/Play",
	round((sum(tgs.rushatts) + sum(tgs.passatts)) / COUNT(DISTINCT game.gameid), 2) as "Plays/G",
	round(sum(tgs.rushyards) / COUNT(DISTINCT game.gameid), 2) as "Rush Yards/G",
	round(sum(tgs.rushatts) / COUNT(DISTINCT game.gameid), 2) as "Rush Atts/G",
	round(sum(tgs.rushyards) / sum(tgs.rushatts), 2) as "Rush Avg",
	round(sum(tgs.passyards) / COUNT(DISTINCT game.gameid), 2) as "Pass Yards/G",
	round(sum(tgs.passatts) / COUNT(DISTINCT game.gameid), 2) as "Pass Atts/G",
	round(sum(tgs.passyards) /sum(tgs.passatts), 2) as "Pass Yards/Att"
FROM
    teamgamestat as tgs
    JOIN team ON team.teamid = tgs.teamid
    JOIN game ON game.gameid = tgs.gameid
    WHERE
        game.year = :year
    GROUP BY team.teamid
) AS teamoffense
where 
	teamoffense.teamid = :teamid
UNION
select
	"Defense" as "Team",
	teamdefense.*
from
(select 
	team1.teamid,
	sum(tgs2.points) / COUNT(DISTINCT game.gameid) as "Points/G",	
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / COUNT(DISTINCT game.gameid), 2)  as "Yards/G",
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / (sum(tgs2.rushatts) + SUM(tgs2.passatts)), 2) as "Yards/Play",
	round((sum(tgs2.rushatts) + sum(tgs2.passatts)) / COUNT(DISTINCT game.gameid), 2) as "Plays/G",
	round(sum(tgs2.rushyards) / COUNT(DISTINCT game.gameid), 2) as "Rush Yards/G",
	round(sum(tgs2.rushatts) / COUNT(DISTINCT game.gameid), 2) as "Rush Atts/G",
	round(sum(tgs2.rushyards) / sum(tgs2.rushatts), 2) as "Rush Avg",
	round(sum(tgs2.passyards) / COUNT(DISTINCT game.gameid), 2) as "Pass Yards/G",
	round(sum(tgs2.passatts) / COUNT(DISTINCT game.gameid), 2) as "Pass Atts/G",
	round(sum(tgs2.passyards) /sum(tgs2.passatts), 2) as "Pass Yards/Att"
from teamgamestat AS tgs1 
    JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
    JOIN game as game ON tgs1.gameid = game.gameid
    JOIN team as team1 on team1.teamid = tgs1.teamid
where
	game.year = :year 
group by
	team1.teamid
) as teamdefense
where
	teamdefense.teamid = :teamid;