-- Team total scoring defense
select teamstats.* from
(SELECT 
    row_number() over (order by t.pointspergame asc) as '#',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.tds as 'TDs',
    t.fgs as 'FGs',
    t.xps as 'XP1s',
    t.points as 'Points',
    t.pointspergame as 'Points/G'
from (    
select 
	team1.teamid as teamid,
	count(distinct game.gameid) as games,
	sum(tgs2.passtds) + sum(tgs2.rushtds) + sum(tgs2.puntreturntds) + sum(tgs2.kickreturntds) + sum(tgs2.deftds) as tds,
	sum(tgs2.fieldgoalsmade) as fgs,
	sum(tgs2.xpsmade) as xps,
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
) as t
) as teamstats
where
	teamstats.teamid = :teamid
