-- Player Rushing Offense for a specific game

select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    pgs.rushatts as Atts,
    pgs.rushyards as Yards,
    round(pgs.rushyards / pgs.rushatts, 2) as Avg,
    pgs.rushtds as TD,
    pgs.rushlong as "Long"
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	pgs.rushatts > 0
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	pgs.rushyards desc
