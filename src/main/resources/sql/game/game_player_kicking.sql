-- Player stats for a specific game
-- FG	PCT	LONG	XP	PTS
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
	concat(pgs.fieldgoalsmade, ' / ', pgs.fieldgoalatts) as 'FGs/Att',
	round(pgs.fieldgoalsmade / pgs.fieldgoalatts, 2) as 'Pct',
	max(pgs.fieldgoallong) as 'Long',
	concat(pgs.xpsmade, ' / ', pgs.xpatts) as 'XPs',
	(pgs.fieldgoalsmade * 3) + pgs.xpsmade as 'Points'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.gameid = ? and
	(pgs.fieldgoalatts > 0 or pgs.xpatts > 0)
group by 
	player.playername, 
	player.playerid,
    team.teamid
order by
	pgs.fieldgoalsmade desc