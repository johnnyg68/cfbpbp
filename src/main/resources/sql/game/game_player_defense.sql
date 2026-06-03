-- Player defensive stats for a specific game
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    pgs.tackles as Total,
    pgs.tacklessolo as Solo,
    pgs.qbhurries as QBH,
    pgs.sacks as Sacks,
    pgs.tacklesforloss as TFL,
    pgs.passesdefended as PBU
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	(pgs.tackles > 0 or pgs.passesdefended > 0)
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	pgs.tackles desc;
	
	
