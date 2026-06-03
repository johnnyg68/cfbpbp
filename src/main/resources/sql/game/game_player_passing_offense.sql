-- Player passing for a specific game.  
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    concat(pgs.passcomps, " / ", pgs.passatts) as 'Comps/Atts',
    pgs.passyards as Yards,
    round(pgs.passyards / pgs.passatts, 2) as 'Yards/Att',
    pgs.passtds as TD,
    pgs.passints as 'INT',
    --  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    round(((8.4 * pgs.passyards) + (330 * pgs.passtds) - (200 * pgs.passints) + (100 * pgs.passcomps)) / pgs.passatts, 2) as Rating
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and 
	pgs.passatts > 0
group by 
	player.playername, 
	player.playerid,
	team.teamid
order by
	pgs.passyards desc
