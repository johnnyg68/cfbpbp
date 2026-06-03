-- defensive play explosiveness
select
	row_number() over (order by t.Pct asc) as '#',
	t.name as Team,
    t.teamid as TeamId,
    t.Plays as Plays,
    t.20plus as '20+',
    t.30plus as '30+',
    t.40plus as '40+',
    t.50plus as '50+',
    t.60plus as '60+',
    t.70plus as '70+',
    t.80plus as '80+',
    t.90plus as '90+',
    t.Pct as 'Pct of Plays > 20'
from(    
select
	team.name,
    team.teamid,
    count(play.offenseteamid) as Plays,
    count(case when play.playstatyardage >= 20 then 1 end) as 20plus,
    count(case when play.playstatyardage >= 30 then 1 end) as 30plus,
    count(case when play.playstatyardage >= 40 then 1 end) as 40plus,
    count(case when play.playstatyardage >= 50 then 1 end) as 50plus,
    count(case when play.playstatyardage >= 60 then 1 end) as 60plus,
    count(case when play.playstatyardage >= 70 then 1 end) as 70plus,
    count(case when play.playstatyardage >= 80 then 1 end) as 80plus,
    count(case when play.playstatyardage >= 90 then 1 end) as 90plus,
    round(count(case when play.playstatyardage >= 20 then 1 end) / count(play.defenseteamid) * 100, 2) as Pct
from
	play
	join team on team.teamid = play.defenseteamid
    join game on game.gameid = play.gameid
    join conference as conf on conf.conferenceid = team.conferenceid
where
	game.year = :year and
    conf.division = 'FBS' -- and
    -- play.playtypeid in (4,5,24,51,67,68)
group by
	team.teamid,
    game.year
) as t
