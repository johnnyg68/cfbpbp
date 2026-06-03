-- Team Total Pass Defense
select teamstats.* from
(SELECT 
    row_number() over (order by t.yardspergame desc) as '#',
    t.teamid AS 'TeamId',
    t.games AS 'Games',
    t.atts AS 'Atts',
    t.comps AS 'Comps',
    t.pct AS 'Pct',
    t.yards AS 'Yards',
    t.yardsperatt AS 'Yards/Att',
    t.tds AS 'TDs',
	t.ints as 'INT',
	t.QBR as QBR,
	t.attspergame as 'Atts/G',
	t.yardspergame as 'Yards/G'
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
	round(((8.4 * sum(tgs2.passyards)) + (330 * sum(tgs2.passtds)) - (200 * sum(tgs2.passints)) + (100 * sum(tgs2.passcomps))) / sum(tgs2.passatts), 2) as QBR,
	round(sum(tgs2.passatts) / count(distinct game.gameid), 2) as attspergame,
	round(sum(tgs2.passyards) / count(distinct game.gameid), 2) as yardspergame
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
	) as t
) as teamstats
