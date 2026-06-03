-- Player career punt returns
select 
	game.year as Year,
	player.playername as Name,
    team.name as Team,
    team.teamid as TeamId,
    count(distinct game.gameid) as 'Games',
    sum(pgs.puntreturns) as 'Returns',
    sum(pgs.puntreturnyards) as 'Yards',
    round(sum(pgs.puntreturnyards) / sum(pgs.puntreturns), 2) as 'Avg',
    max(pgs.puntreturnlong) as 'Long',
    sum(pgs.puntreturntds) as 'TD' 
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	pgs.playerid = ? and
	pgs.puntreturns > 0
group by 
	game.year,
	player.playerid,
    team.teamid
order by
	game.year