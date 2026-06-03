select teamstats.* from
(SELECT 
    row_number() over (order by t.Yards_Game desc) as '#',
    t.teamid as TeamId,
    t.GAMES as Games,
    t.ATT as Atts,
    t.COMP as Comps,
    t.PCT as Pct,
	t.YARDS as Yards,
    t.Yards_Att AS 'Yards/Att',
    t.TD as TD,
    t.INTS as 'INT',
    t.Rating as Rating,
	t.Att_Game as 'Atts/G',
	t.Yards_Game as 'Yards/G'
FROM (
select 
	team.teamid as teamid,
	count(distinct game.gameid) as GAMES,
	sum(tgs.passatts) as ATT,
	sum(tgs.passcomps) as COMP,
	round(sum(tgs.passcomps) / sum(tgs.passatts) * 100, 2) as PCT,
	sum(tgs.passyards) as YARDS,
	round(sum(tgs.passyards) / sum(tgs.passatts), 2) as Yards_Att,
	sum(tgs.passtds) as TD,
	sum(tgs.passints) as 'INTS',
	--  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    round(((8.4 * sum(tgs.passyards)) + (330 * sum(tgs.passtds)) - (200 * sum(tgs.passints)) + (100 * sum(tgs.passcomps))) / sum(tgs.passatts), 2) as Rating,
	round(sum(tgs.passatts) / count(distinct game.gameid), 1) as 'Att_Game',
	round(sum(tgs.passyards) / count(distinct game.gameid), 2) as 'Yards_Game'
from 
	teamgamestat as tgs
	join team on team.teamid = tgs.teamid
	join game on game.gameid = tgs.gameid	
	join conference on conference.conferenceid = team.conferenceid
where
	game.year = :year and
	conference.division = 'FBS' 
group by 
	team.teamid
) as t
) as teamstats
where teamstats.teamid = :teamid