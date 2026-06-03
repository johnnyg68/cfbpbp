-- Team Player Career Receiving
select 
	-- game.year as Year,
	player.playername as Name,
	player.playerid as PlayerId,
    concat(min(game.year), " - ", max(game.year)) as Years,
    count(distinct pgs.gameid) as Games,
    sum(pgs.passrecs) as Recs,
    sum(pgs.passrecyards) as Yards,
    round(sum(pgs.passrecyards) / sum(pgs.passrecs), 2) as 'Yards/Rec',
    sum(pgs.passrectds) as TD,
    max(pgs.passreclong) as 'Long',
    round(sum(pgs.passrecs) / count(distinct pgs.gameid), 2) as 'Recs/G',
    round(sum(pgs.passrecyards) / count(distinct pgs.gameid), 2) as 'Yards/G'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    -- join teamgamestat as tgs on tgs.gameid = game.gameid
where 
	team.teamid = :teamid
group by 
	-- game.year,
	player.playerid,
    team.teamid
having
	sum(pgs.passrecs) > 0
order by
	sum(pgs.passrecyards) desc
limit 100; 