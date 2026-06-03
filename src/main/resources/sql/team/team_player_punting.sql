-- Player stats for a specific game
-- NO	YDS	AVG	TB	IN 20	LONG
select 
	player.playername as Name,
    player.playerid as PlayerId,
	sum(pgs.punts) as Punts,
	sum(pgs.puntyards) as Yards,
	round(sum(pgs.puntyards) / sum(pgs.punts), 2) as Avg,
	sum(pgs.punttouchbacks) as TBs,
	sum(pgs.puntsinside20) as 'In 20',
	max(pgs.puntlong) as 'Long'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	team.teamid = :teamid and
	game.year = :year and
	pgs.punts > 0
group by 
	player.playername, 
	player.playerid
order by
	sum(pgs.punts) desc