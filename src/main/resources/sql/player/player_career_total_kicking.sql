-- Player career kicking
select 
	'Total' as 'Year',
    '' as 'Team',
    count(distinct pgs.gameid) as Games,
    sum(pgs.fieldgoalsmade) as FG,
    sum(pgs.fieldgoalatts) as Att,
    round(sum(pgs.fieldgoalsmade) / sum(pgs.fieldgoalatts) * 100, 2) as 'Pct',
	max(pgs.fieldgoallong) as 'Long',
	sum(pgs.xpsmade) as 'XP',
	sum(pgs.xpatts) as 'XP Att',
	(sum(pgs.fieldgoalsmade) * 3) + sum(pgs.xpsmade) as 'Points'
from playergamestat as pgs
	join team on team.teamid = pgs.teamid
	-- join game on game.gameid = pgs.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	pgs.playerid = ? and
	(pgs.fieldgoalatts > 0 or pgs.xpatts > 0)
group by 
	player.playerid,
    team.teamid
