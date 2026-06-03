-- Player stats for a specific game
-- NO	YDS	AVG	TB	IN 20	LONG
select 
	player.playername as Name,
	player.playerId as PlayerId,
    team.name as Team,
	pgs.punts as Punts,
	pgs.puntyards as Yards,
	round(pgs.puntyards / pgs.punts, 2) as Avg,
	pgs.punttouchbacks as TBs,
	pgs.puntsinside20 as "In 20",
	pgs.puntlong as "Long"
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	pgs.punts > 0
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	pgs.punts desc