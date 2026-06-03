-- team total passing offense and defense by yards/game
select teamoffense.* from
(SELECT 
	'Offense' as '',
    @row1:=@row1 + 1 AS '#',
    t.teamid as TeamId,
    t.GAMES as Games,
    t.ATT as Atts,
    t.COMP as Comps,
    t.PCT as Pct,
	t.YARDS as Yards,
    t.Yards_Att AS 'Yards/Att',
    t.TD as TDs,
    t.INTS as 'Ints',
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
	round(sum(tgs.passatts) / count(distinct game.gameid), 2) as 'Att_Game',
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
order by
	round(sum(tgs.passyards) / count(distinct game.gameid) ,2) desc) as t
CROSS JOIN
    (SELECT @row1:=0) AS r) as teamoffense
where teamoffense.teamid = :teamid
UNION
-- Team Total Pass Defense
select teamdefense.* from
(SELECT 
	'Defense' as '',
    @row2:=@row2 + 1 AS '#',
    t.teamid AS 'TeamId',
    t.games AS 'Games',
    t.atts AS 'Atts',
    t.comps AS 'Comps',
    t.pct AS 'Pct',
    t.yards AS 'Yards',
    t.yardsperatt AS 'Yards/Att',
    t.tds AS 'TDs',
	t.ints as 'Ints',
   	t.Rating as Rating,
	t.Atts_G as 'Atts/G',
	t.Yards_G as 'Yards/G'
from (
select
	team1.teamid,
	count(distinct game.gameid) as games,
	sum(tgs2.passatts) as atts,
	sum(tgs2.passcomps) as comps,
	round((sum(tgs2.passcomps) / sum(tgs2.passatts)) * 100, 2) as pct,
	sum(tgs2.passyards) as yards,
	round(sum(tgs2.passyards) / sum(tgs2.passatts), 2) as yardsperatt,
	sum(tgs2.passtds) as tds,
	sum(tgs2.passints) as ints,	
	round(((8.4 * sum(tgs2.passyards)) + (330 * sum(tgs2.passtds)) - (200 * sum(tgs2.passints)) + (100 * sum(tgs2.passcomps))) / sum(tgs2.passatts), 2) as Rating,
    round(sum(tgs2.passatts) / count(distinct game.gameid), 2) as Atts_G,
	round(sum(tgs2.passyards) / count(distinct game.gameid), 2) as Yards_G
from
	teamgamestat as tgs1
	join teamgamestat as tgs2 on tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
	join game as game on game.gameid = tgs1.gameid
	join team as team1 on team1.teamid = tgs1.teamid
	join conference as conf on conf.conferenceid = team1.conferenceid
where
	game.year = :year and
	conf.division = 'FBS' 
group by 
	team1.teamid
order by
	sum(tgs2.passyards) / count(distinct game.gameid) asc
	) as t
CROSS JOIN
    (SELECT @row2:=0) AS r
) as teamdefense
where teamdefense.teamid = :teamid;