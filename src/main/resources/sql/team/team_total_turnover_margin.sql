select allteams.* from
(SELECT 
    row_number() over (order by t.MarginG desc) as '#',
    t.name as Team,
    t.teamid as TeamId,
    t.Games as Games,
    t.fumbleslost as 'Fumbles',
    t.intsthrown as 'Ints',
    t.Turnovers as 'Turnovers',
    t.fumblesgained as 'Fumbles Gained',
    t.intsgained as 'Ints Gained',
    t.turnoversgained as 'Turnovers Gained',
    t.Margin as 'Margin',
    t.MarginG as 'Margin/G'
from(
select
	team.name,
    team.teamid,
    count(distinct game.gameid) as games,
    sum(tgs1.fumbleslost) as 'fumbleslost',
    sum(tgs1.interceptions) as 'intsthrown',
	sum(tgs1.turnovers) as 'Turnovers',
    sum(tgs2.fumbleslost) as 'fumblesgained',
    sum(tgs2.interceptions) as 'intsgained',
	sum(tgs2.turnovers) as 'turnoversgained',
    sum(tgs2.turnovers) - sum(tgs1.turnovers) as 'Margin',
    round((sum(tgs2.turnovers) - sum(tgs1.turnovers)) / count(distinct game.gameid), 2) as 'MarginG'
from
	teamgamestat as tgs1
    join teamgamestat as tgs2 on tgs2.gameid = tgs1.gameid and tgs1.teamid <> tgs2.teamid
    join team as team on team.teamid = tgs1.teamid
    join game as game on game.gameid = tgs1.gameid
    join conference as conf on conf.conferenceid = team.conferenceid
where
	game.year = :year and
    conf.division = 'FBS' 
group by
	team.name, team.teamid
) as t
) as allteams
join
	team on team.teamid = allteams.teamid
	where team.teamid = :teamid