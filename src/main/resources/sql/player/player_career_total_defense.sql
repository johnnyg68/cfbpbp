-- Player career total defense
select 
	'Total' as 'Year',
    '' as 'Team',
    count(distinct pgs.gameid) as Games,
    sum(pgs.tackles) as Tackles,
    round(sum(pgs.tackles) / count(distinct pgs.gameid), 2) as 'Tackles/G',
    sum(pgs.tacklessolo) as Solo,
    sum(pgs.sacks) as Sacks,
    sum(pgs.tacklesforloss) as TFL,
    sum(pgs.passesdefended) as PBU,
    sum(pgs.defints) as 'INT',
    sum(pgs.defintyards) as Yards,
    sum(pgs.definttds) as TD
from playergamestat as pgs
join team on team.teamid = pgs.teamid
-- join game on game.gameid = pgs.gameid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	player.playerid = ? and 
	(pgs.tackles > 0 or pgs.passesdefended > 0)
group by 
	player.playerid,
    team.teamid
