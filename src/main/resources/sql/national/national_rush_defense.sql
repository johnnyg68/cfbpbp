-- National rush defense
-- includes AP ranking and W-L record

SELECT 
    @row:=@row + 1 AS '#',
    t.name as 'Team',
    t.teamid as 'TeamId',
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
    t.games as 'Games',
    t.atts as 'Atts',
    t.yards as 'Yards',
    t.Avg as 'Avg',
    t.tds as 'TDs',
	t.AttsPerGame as 'Atts/G',
	t.YardsPerGame as 'Yards/G'
from (
select
	team1.name as name,
	team1.teamid as teamid,
    ap_poll.ranking,
	count(distinct game.gameid) as games,
	sum(tgs2.rushatts) as atts,
	sum(tgs2.rushyards) as Yards,
	round(sum(tgs2.rushyards) / sum(tgs2.rushatts), 2) as Avg,
	sum(tgs2.rushtds) as tds,
	round(sum(tgs2.rushatts) / count(distinct game.gameid), 2) as AttsPerGame, 
	round(sum(tgs2.rushyards) / count(distinct game.gameid), 2) as YardsPerGame
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
order by
	round(sum(tgs2.rushyards) / count(distinct game.gameid), 2) asc
	) as t
            CROSS JOIN
    (SELECT @row:=0) AS r