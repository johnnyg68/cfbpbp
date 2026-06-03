--  Team total scoring offense and defense
select teamoffense.* from 
(SELECT 
	'' as 'Offense',
    @row1:=@row1 + 1 AS '#',
    t.teamid as 'TeamId',
    t.games as Games,
    t.TD as TD,
    t.FG as FG,
    t.XP1 as XP1,
    t.POINTS as Points,
	t.POINTS_GAME as 'Points/G'
from (
select 
	team.teamid as teamid,
	count(distinct game.gameid) as games,
	sum(tgs.rushtds) + sum(tgs.passtds) + sum(tgs.kickreturntds) + sum(tgs.puntreturntds) + sum(tgs.deftds) as TD,
	sum(tgs.fieldgoalsmade) as FG,
	sum(tgs.xpsmade) as "XP1",
	SUM(tgs.points) as POINTS,
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
order by
	sum(tgs.points) / count(distinct game.gameid) desc) as t
CROSS JOIN
    (SELECT @row1:=0) AS r) as teamoffense
where teamoffense.teamid = :teamid
UNION
select teamdefense.* from
(SELECT 
	'' as 'Defense',
    @row2:=@row2 + 1 AS '#',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.tds as 'TDs',
    t.fgs as 'FGs',
    t.XP1 as 'XP1',
    t.points as 'Points',
    t.pointspergame as 'Points/G'
from (    
select 
	team1.teamid as teamid,
	count(distinct game.gameid) as games,
	sum(tgs2.passtds) + sum(tgs2.rushtds) + sum(tgs2.puntreturntds) + sum(tgs2.kickreturntds) + sum(tgs2.deftds) as tds,
	sum(tgs2.fieldgoalsmade) as fgs,
	sum(tgs2.xpsmade) as XP1,
	sum(tgs2.points) as points,
	round(sum(tgs2.points) / count(distinct game.gameid), 2) as pointspergame 
from teamgamestat AS tgs1 
    JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
    JOIN game as game ON tgs1.gameid = game.gameid
    JOIN team as team1 on team1.teamid = tgs1.teamid
    join conference as conference on conference.conferenceid = team1.conferenceid
where
	game.year = :year and
	conference.division = 'FBS'
group by
	team1.teamid
order by
	sum(tgs2.points) / count(distinct game.gameid) asc
) as t
CROSS JOIN
    (SELECT @row2:=0) AS r ) as teamdefense
where
	teamdefense.teamid = :teamid
