-- Team total scoring offense
select teamstats.* from 
(select 
    row_number() over (order by t.POINTS_GAME desc) as '#',
    t.TEAMID as TeamId,
    t.GAMES as Games,
    t.TD as TD,
    t.FG as FG,
    t.1XP as 1XP,
    t.POINTS as Points,
	t.POINTS_GAME as 'Points/G'
from (
select 
	team.teamid as TEAMID,
	count(distinct game.gameid) as GAMES,
	sum(tgs.rushtds) + sum(tgs.passtds) + sum(tgs.kickreturntds) + sum(tgs.puntreturntds) + sum(tgs.deftds) as TD,
	sum(tgs.fieldgoalsmade) as FG,
	sum(tgs.xpsmade) as 1XP,
	sum(tgs.points) as POINTS,
	round(sum(tgs.points) / count(distinct game.gameid), 2) as POINTS_GAME
from 
	teamgamestat as tgs
	join game as game on game.gameid = tgs.gameid
	join team as team on team.teamid = tgs.teamid
	join conference ON conference.conferenceid = team.conferenceid
where 
	game.year = :year and
	conference.division = 'FBS'
group by
	team.teamid
) as t
) as teamstats
where teamstats.teamid = :teamid