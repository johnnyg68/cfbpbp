-- Team Player Career Passing
select 
	-- game.year as Year,
	player.playername as Name,
    player.playerid as PlayerId,
    concat(min(game.year), " - ", max(game.year)) as Years,
    count(distinct pgs.gameid) as Games,
    sum(pgs.passcomps) as Comps,
    sum(pgs.passatts) as Atts,
    ROUND(sum(pgs.passcomps) / sum(pgs.passatts) * 100, 2) as Pct,
    sum(pgs.passyards) as Yards,
    ROUND(sum(pgs.passyards) / sum(pgs.passatts), 2) as 'Yards/Att',
    sum(pgs.passtds) as TD,
    sum(pgs.passints) as 'INT',
    --  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    ROUND(((8.4 * sum(pgs.passyards)) + (330 * sum(pgs.passtds)) - (200 * sum(pgs.passints)) + (100 * sum(pgs.passcomps))) / sum(pgs.passatts), 2) as Rating,
    ROUND(sum(pgs.passatts) / count(distinct pgs.gameid), 2) as 'Att/G',
    ROUND(sum(pgs.passyards) / count(distinct pgs.gameid), 2) as 'Yards/G'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where
	pgs.passatts > 0 and
    team.teamid = :teamid
group by 
	-- game.year,
	player.playerid,
    team.teamid
order by
	round(sum(pgs.passyards)) desc
limit 100	