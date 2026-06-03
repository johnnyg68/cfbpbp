-- National Team Pass Defense
-- includes AP ranking and W-L record

SELECT 
    row_number() over (order by t.yardspergame asc) as '#',
    t.name AS 'Team',
    t.teamid AS 'TeamId',
    IFNULL(t.ranking, "NR") as "AP ranking",
    (select 
		concat(
			count(CAST(case when game.winnerteamid = team.teamid then 1 end as CHAR)), 
			CAST(' - ' as CHAR), 
			count(CAST(case when game.winnerteamid <> team.teamid then 1 end as CHAR))
		) 
	from team 
		join game on team.teamid = game.hometeamid or team.teamid = game.awayteamid  
	where 
		team.teamid = t.teamid and 
		game.year = :year
	group by 
		game.year) as 'Record',
    t.games AS 'Games',
    t.atts AS 'Atts',
    t.comps AS 'Comps',
    t.pct AS 'Pct',
    t.yards AS 'Yards',
    t.yardsperatt AS 'Yards/Att',
    t.tds AS 'TDs',
	t.ints as 'Ints',
	t.Rating as 'Rating',
	t.attspergame as 'Atts/G',
	t.yardspergame as 'Yards/G'
from (
select
	team1.name,
	team1.teamid,
    ap_poll.ranking,
	count(distinct game.gameid) as games,
	sum(tgs2.passatts) as atts,
	sum(tgs2.passcomps) as comps,
	round((sum(tgs2.passcomps) / sum(tgs2.passatts)) * 100, 2) as pct,
	sum(tgs2.passyards) as yards,
	round(sum(tgs2.passyards) / sum(tgs2.passatts), 2) as yardsperatt,
	sum(tgs2.passtds) as tds,
	sum(tgs2.passints) as ints,	
	round(((8.4 * sum(tgs2.passyards)) + (330 * sum(tgs2.passtds)) - (200 * sum(tgs2.passints)) + (100 * sum(tgs2.passcomps))) / sum(tgs2.passatts), 2) as Rating,
	round(sum(tgs2.passatts) / count(distinct game.gameid), 2) as attspergame,
	round(sum(tgs2.passyards) / count(distinct game.gameid), 2) as yardspergame
from
	teamgamestat as tgs1
	inner join teamgamestat as tgs2 on tgs1.gameid = tgs2.gameid
	join game as game on game.gameid = tgs1.gameid
	inner join team as team1 on team1.teamid = tgs1.teamid
	inner join team as team2 on team2.teamid = tgs2.teamid
	join conference as conf on conf.conferenceid = team1.conferenceid
    left join ap_poll on ap_poll.teamid = team1.teamid and ap_poll.year = game.year
where
	game.year = :year and
	conf.division = 'FBS' and
	tgs1.points <> tgs2.points
group by 
	team1.name, team1.teamid, ap_poll.ranking
) as t