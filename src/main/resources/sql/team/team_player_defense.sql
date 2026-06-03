-- Player stats for a team
select 
	player.playername as Name,
	player.playerid as PlayerId,
	count(distinct pgs.gameid) as Games,
    sum(pgs.tackles) as Total,
    sum(pgs.tacklessolo) as Solo,
    sum(pgs.sacks) as Sacks,
    sum(pgs.tacklesforloss) as TFL,
    sum(pgs.passesdefended) as PBU
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.year = :year and
	team.teamid = :teamid and
	(pgs.tackles > 0 or pgs.passesdefended > 0)
group by 
	player.playername, 
	player.playerid
order by
	sum(pgs.tackles) desc;
	
	
