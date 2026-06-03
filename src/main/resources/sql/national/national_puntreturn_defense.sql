-- National Team Punt Return Defense
-- includes AP ranking and W-L record

SELECT 
    row_number() over (order by t.avg asc) as '#',
    t.name as Team,
    t.teamid as TeamId,
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
    t.games as Games,
    t.No as No,
    t.yards as Yards,
    t.long as "Long",
	t.td as "TD",
	t.avg as Avg
from (
select
	team1.name,
	team1.teamid,
    ap_poll.ranking,
	count(distinct game.gameid) as games,
    sum(tgs2.puntreturns) as "No",
    sum(tgs2.puntreturnyards) as yards,
    round(sum(tgs2.puntreturnyards) / sum(tgs2.puntreturns), 2) as avg,
    max(tgs2.puntreturnlong) as "long",
    sum(tgs2.puntreturntds) as "td" 
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