-- Player Receiving Offense for a specific game

select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    pgs.passrecs as Recs,
    pgs.passrecyards as Yards,
    round(pgs.passrecyards / pgs.passrecs, 2) as Avg,
    pgs.passrectds as TD,
	pgs.passreclong as "Long"
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	pgs.passrecs > 0
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	sum(pgs.passrecyards) desc
