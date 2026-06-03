-- Team player kicking for a year
select 
	player.playername as Name,
	player.playerid as PlayerId,
	sum(pgs.fieldgoalsmade) as 'FGs',
	sum(pgs.fieldgoalatts) as 'Atts',
	round(sum(pgs.fieldgoalsmade) / sum(pgs.fieldgoalatts) * 100, 2) as 'Pct',
	max(pgs.fieldgoallong) as 'Long',
	sum(pgs.xpsmade) as 'XPs',
	sum(pgs.xpatts) as 'XP Atts',
	(sum(pgs.fieldgoalsmade) * 3) + sum(pgs.xpsmade) as 'Points'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	team.teamid = :teamid and
	game.year = :year and
	(pgs.fieldgoalatts > 0 or pgs.xpatts > 0)
group by 
	player.playername, 
	player.playerid
order by
	sum(pgs.fieldgoalsmade) desc