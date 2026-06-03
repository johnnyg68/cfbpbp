-- First Downs Offense

SELECT 
    row_number() over (order by t.totalpergame desc) as '#',
   	t.name as Name,
    t.games as Games,
    t.total as Total,
    t.totalpergame as 'Total/G'
from (
select 
	team.name, 
    count(distinct game.gameid) as games,
    sum(tgs.firstdowns) as total, 
	round(sum(tgs.firstdowns) / count(distinct game.gameid), 2) as totalpergame
from
	teamgamestat as tgs
    join game on game.gameid = tgs.gameid
    join team on team.teamid = tgs.teamid   
    join conference on conference.conferenceid = team.conferenceid
where
	game.year = :year and
    conference.division = 'FBS'
group by
	team.name
) as t
