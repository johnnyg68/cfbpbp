-- Team Player Passing
select 
	player.playername as Name,
	player.playerid as PlayerId,
    count(distinct pgs.gameid) as Games,
    sum(pgs.passcomps) as Comp,
    sum(pgs.passatts) as Att,
    sum(pgs.passyards) as Yards,
    round(sum(pgs.passcomps) / sum(pgs.passatts) * 100, 2) as Pct,
    round(sum(pgs.passyards) / sum(pgs.passatts), 2) as 'Yards/Att',
    sum(pgs.passtds) as TD,
    sum(pgs.passints) as 'INT',
    --  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    round(((8.4 * sum(pgs.passyards)) + (330 * sum(pgs.passtds)) - (200 * sum(pgs.passints)) + (100 * sum(pgs.passcomps))) / sum(pgs.passatts), 2) as Rating,
    round(sum(pgs.passatts) / count(distinct pgs.gameid), 2) as 'Att/G',
    round(sum(pgs.passyards) / count(distinct pgs.gameid), 2) as 'Yards/G'
from playergamestat as pgs
join team on team.teamid = pgs.teamid
join game on game.gameid = pgs.gameid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.year = :year and
	team.teamid = :teamid and 
	pgs.passatts > 0 
group by 
	player.playerid
order by
	sum(pgs.passyards) / count(distinct pgs.gameid) desc
