-- Player INT stats for a team and year
select 
	player.playername as Name,
	player.playerid as PlayerId,
    sum(pgs.defints) as "INT",
    sum(pgs.defintyards) as "Yards",
    max(pgs.defintyards) as "Long",
    sum(pgs.deftds) as "TD"    
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	team.teamid = :teamid and
	game.year = :year and
	pgs.defints > 0
group by 
	player.playername, 
	player.playerid
order by
	sum(pgs.defints) desc