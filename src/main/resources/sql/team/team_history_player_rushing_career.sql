-- Team Player Career Rushing
select 
	-- game.year as Year,
	player.playername as Name,
	player.playerid as PlayerId,
    concat(min(game.year), " - ", max(game.year)) as Years,
    count(distinct pgs.gameid) as Games,
    sum(pgs.rushatts) as Atts,
    sum(pgs.rushyards) as Yards,
    round(sum(pgs.rushyards) / sum(pgs.rushatts), 2) as Avg,
    sum(pgs.rushtds) as TD,
    max(pgs.rushlong) as 'Long',
    round(sum(pgs.rushatts) / count(distinct pgs.gameid), 2) as 'Atts/G',
    round(sum(pgs.rushyards) / count(distinct pgs.gameid), 2) as 'Yards/G'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	team.teamid = :teamid
group by 
	-- game.year,
	player.playerid,
    team.teamid
having
	sum(pgs.rushatts) > 0
order by
	sum(pgs.rushyards) desc  
limit 100