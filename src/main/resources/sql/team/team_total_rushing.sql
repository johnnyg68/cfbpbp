-- Team Total Rushing Offense and Defense by yards/game
select
	"Offense" as "Team",
	teamoffense.* 
from
(SELECT 
	team.teamid,
	row_number() over (order by SUM(tgs.rushyards) / COUNT(DISTINCT game.gameid) DESC) as "#",
    COUNT(DISTINCT game.gameid) AS Games,
    SUM(tgs.rushatts) AS Att,
    SUM(tgs.rushyards) AS Yards,
    ROUND(SUM(tgs.rushyards) / SUM(tgs.rushatts), 2) AS Avg,
    SUM(tgs.rushtds) as TD,
    ROUND(SUM(tgs.rushatts) / COUNT(DISTINCT game.gameid), 2) AS "Atts/Game",
    ROUND(SUM(tgs.rushyards) / COUNT(DISTINCT game.gameid), 2) AS "Yards/Game"
FROM
    teamgamestat as tgs
    JOIN team ON team.teamid = tgs.teamid
    JOIN game ON game.gameid = tgs.gameid
    JOIN conference ON conference.conferenceid = team.conferenceid
    WHERE
        game.year = :year AND 
        conference.division = 'FBS'
    GROUP BY 
    	team.teamid
) AS teamoffense
where teamoffense.teamid = :teamid
UNION
-- Team total rushing defense
select
	"Defense" as "Team",
	teamdefense.* 
from (
select
	team1.teamid as teamid,
	row_number() over (order by round(sum(tgs2.rushyards) / count(distinct game.gameid), 2) ASC) as "#",
	count(distinct game.gameid) as Games,
	sum(tgs2.rushatts) as Atts,
	sum(tgs2.rushyards) as Yards,
	round(sum(tgs2.rushyards) / sum(tgs2.rushatts), 2) as Avg,
	sum(tgs2.rushtds) as TD,
	round(sum(tgs2.rushatts) / count(distinct game.gameid), 2) as "Att/Game", 
	round(sum(tgs2.rushyards) / count(distinct game.gameid), 2) as "Yards/Game"
from
	teamgamestat as tgs1
	join teamgamestat as tgs2 on tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
	join game as game on game.gameid = tgs1.gameid
	join team as team1 on team1.teamid = tgs1.teamid
	join conference as conf on conf.conferenceid = team1.conferenceid
where
	game.year = :year and
	conf.division = 'FBS'
group by 
	team1.teamid
) as teamdefense
where teamdefense.teamid = :teamid