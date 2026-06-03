-- Team Player Rushing Offense.  Player rushing totals for a given team

select 
	player.playername as Name,
	player.playerid as PlayerId,
    count(distinct pgs.gameid) as Games,
    sum(pgs.rushatts) as Att,
    sum(pgs.rushyards) as Yards,
    round(sum(pgs.rushyards) / sum(pgs.rushatts), 2) as Avg,
    sum(pgs.rushtds) as TD,
    max(pgs.rushlong) as "Long",
    round(sum(pgs.rushatts) / count(distinct pgs.gameid), 2) as "Atts/G",
    round(sum(pgs.rushyards) / count(distinct pgs.gameid), 2) as "Yards/G"
from playergamestat as pgs
join team on team.teamid = pgs.teamid
join game on game.gameid = pgs.gameid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.year = :year and 
	team.teamid = :teamid 
group by 
	player.playername, 
	player.playerid
having
	sum(pgs.rushatts) > 0
order by
	sum(pgs.rushyards) / count(distinct pgs.gameid) desc  