-- Player kick return stats for a year
-- Note: To qualify, player must have played in 75% of his team's games and have a minimum of 1.2 punt returns per game played.
SELECT 
    row_number() over (order by t.Avg desc) as '#',
    t.Name,
    t.PlayerId,
    t.Team,
    t.TeamId,
    t.Returns,
    t.Yards,
    t.Long,
    t.TD,
    t.Avg
from(
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    team.teamid as TeamId,
    sum(pgs.kickreturns) as "Returns",
    sum(pgs.kickreturnyards) as "Yards",
    round(sum(pgs.kickreturnyards) / sum(pgs.kickreturns), 2) as "Avg",
    max(pgs.kickreturnlong) as "Long",
    sum(pgs.kickreturntds) as "TD" 
from
	game
	join playergamestat as pgs on pgs.gameid = game.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join conference on conference.conferenceid = team.conferenceid
where 
	game.year = ? and
	pgs.kickreturns > 0
group by 
	-- player.playername, 
	player.playerid,
	team.name,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
) as t
limit 0,100