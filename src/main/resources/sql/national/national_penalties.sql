-- national peanlties by yards pentalized
SELECT 
    row_number() over (order by t.YardsPerGame desc) as '#',
    t.name as Name,
    t.Games as Games,
    t.Penalties,
    t.Yards,
    t.PenaltiesPerGame as 'Penalties/G',
    t.YardsPerGame as 'Yards/G'
from(
select
	team.name,
	count(distinct game.gameid) as Games,
	sum(tgs.penalties) as Penalties,
	sum(tgs.penaltyyards) as Yards,
	round(sum(tgs.penalties) / count(distinct game.gameid), 2) as PenaltiesPerGame,
	round(sum(tgs.penaltyyards) / count(distinct game.gameid), 2) as YardsPerGame
from
	teamgamestat as tgs
	join team as team on team.teamid = tgs.teamid
	join game as game on game.gameid = tgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where
	game.year = :year and
	conference.division = 'FBS'
group by 
	team.name
) as t