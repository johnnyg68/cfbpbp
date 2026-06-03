-- Player career total rushing
select 
	'Total' as 'Year',
    '' as 'Team',
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
-- join game on game.gameid = pgs.gameid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where
	player.playerid = ? and 
	pgs.rushatts > 0
group by 
 	player.playerid,
    player.playername;