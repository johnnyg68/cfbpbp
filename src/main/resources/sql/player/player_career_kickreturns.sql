-- Player stats for a specific game
select 
	game.year as Year,
	player.playername as Name,
    team.name as Team,
    team.teamid as TeamId,
    count(distinct game.gameid) as 'Games',
    sum(pgs.kickreturns) as 'Returns',
    sum(pgs.kickreturnyards) as 'Yards',
    round(sum(pgs.kickreturnyards) / sum(pgs.kickreturns), 2) as 'Avg',
    sum(pgs.kickreturntds) as 'TD', 
    max(pgs.kickreturnlong) as 'Long'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	pgs.kickreturns > 0 and
	player.playerid = ?
group by 
	game.year,
	player.playerid,
    team.teamid
order by
	game.year asc
	