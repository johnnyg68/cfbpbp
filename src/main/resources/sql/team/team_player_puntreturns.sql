-- Team player stats for a year
select 
	player.playername as Name,
    player.playerid as PlayerId,
    sum(pgs.puntreturns) as 'Returns',
    sum(pgs.puntreturnyards) as 'Yards',
    round(sum(pgs.puntreturnyards) / sum(pgs.puntreturns), 2) as 'Avg',
    max(pgs.puntreturnlong) as 'Long',
    sum(pgs.puntreturntds) as 'TD' 
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	team.teamid = :teamid and
	game.year = :year and
	pgs.puntreturns > 0
group by 
	player.playername, 
	player.playerid
order by
	sum(pgs.puntreturns) desc;