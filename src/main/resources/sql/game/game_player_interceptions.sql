-- Player stats for a specific game
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    pgs.defints as "Ints",
    pgs.defintyards as "Yards",
    pgs.deftds as "TDs"    
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	pgs.defints > 0
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	pgs.defints desc