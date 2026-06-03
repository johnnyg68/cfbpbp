-- Player stats for a specific game
select 
	player.playername as Name,
	player.playerid as PlayerId,
    sum(pgs.kickreturns) as 'Returns',
    sum(pgs.kickreturnyards) as 'Yards',    
    round(sum(pgs.kickreturnyards) / sum(pgs.kickreturns), 2) as 'Avg',
    max(pgs.kickreturnlong) as 'Long',
    sum(pgs.kickreturntds) as 'TD' 
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	team.teamid = :teamid and
	game.year = :year and
	pgs.kickreturns > 0
group by 
	player.playername, 
	player.playerid
order by
	sum(pgs.kickreturns) desc;
	

	
	
	