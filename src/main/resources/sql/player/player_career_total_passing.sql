-- /CfbPbpSpring/src/main/java/com/jmg/spring/cfbpbp/sql/player/player_career_total_passing.sql
select 
	'Total' as 'Year',
    '' as 'Team',
    count(distinct pgs.gameid) as Games,
    sum(pgs.passcomps) as Comps,
    sum(pgs.passatts) as Atts,
    round(sum(pgs.passcomps) / sum(pgs.passatts) * 100, 2) as Pct,
    sum(pgs.passyards) as Yards,
    round(sum(pgs.passyards) / sum(pgs.passatts), 2) as 'Yards/Att',
    sum(pgs.passtds) as TD,
    sum(pgs.passints) as 'Int',
    --  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    round(((8.4 * sum(pgs.passyards)) + (330 * sum(pgs.passtds)) - (200 * sum(pgs.passints)) + (100 * sum(pgs.passcomps))) / sum(pgs.passatts), 2) as Rating,
    round(sum(pgs.passatts) / count(distinct pgs.gameid), 2) as 'Att/G',
    round(sum(pgs.passyards) / count(distinct pgs.gameid), 2) as 'Yards/G'
from playergamestat as pgs
join team on team.teamid = pgs.teamid
-- join game on game.gameid = pgs.gameid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where
	player.playerid = ? and 
	pgs.passatts > 0
group by 
	player.playerid,
    player.playername;
