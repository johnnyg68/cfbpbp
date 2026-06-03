-- Player stats for a specific game
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    pgs.puntreturns as 'Returns',
    pgs.puntreturnyards as 'Yards',
    pgs.puntreturnyardsavg as 'Avg',
    pgs.puntreturnlong as 'Long',
    pgs.puntreturntds as 'TD' 
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	pgs.puntreturns > 0
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	pgs.puntreturnyards