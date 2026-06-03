-- Team total rushing defense
select teamstats.* from
(
SELECT 
    row_number() over (order by t.YardsPerGame desc) as '#',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.atts as 'Atts',
    t.yards as 'Yards',
    t.Avg as 'Avg',
    t.tds as 'TDs',
	t.AttsPerGame as 'Atts/G',
	t.YardsPerGame as 'Yards/G'
from (
select
	team1.teamid as teamid,
	count(distinct game.gameid) as games,
	sum(tgs2.rushatts) as atts,
	sum(tgs2.rushyards) as Yards,
	round(sum(tgs2.rushyards) / sum(tgs2.rushatts), 2) as Avg,
	sum(tgs2.rushtds) as tds,
	round(sum(tgs2.rushatts) / count(distinct game.gameid), 2) as AttsPerGame, 
	round(sum(tgs2.rushyards) / count(distinct game.gameid), 2) as YardsPerGame
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
	) as t
) as teamstats
where teamstats.teamid = :teamid