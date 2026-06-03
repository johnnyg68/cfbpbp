--  Team total scoring offense and defense
Select 
	"Offense" as "Team",
	teamoffense.* 
from
(select 
	team.teamid as teamid,
    row_number() over (order by sum(tgs.points) / count(distinct game.gameid) desc) as "#",
	count(distinct game.gameid) as Games,
	sum(tgs.rushtds) + sum(tgs.passtds) + sum(tgs.kickreturntds) + sum(tgs.puntreturntds) + sum(tgs.deftds) as TD,
	sum(tgs.fieldgoalsmade) as FG,
	sum(tgs.xpsmade) as "XP1",
	sum(tgs.points) as Points,
    sum(tgs.points) / (sum(tgs.rushatts) + sum(tgs.passatts)) as "Points/Play",
	round(sum(tgs.points) / count(distinct game.gameid), 2) as "Points/Game"
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
) as teamoffense
where 
	teamoffense.teamid = :teamid
UNION
select 
"Defense" as "Team",
teamdefense.* 
from
(select
	team1.teamid as teamid,
	row_number() over (order by sum(tgs2.points) / count(distinct game.gameid) asc) as "#",
	count(distinct game.gameid) as Games,
	sum(tgs2.passtds) + sum(tgs2.rushtds) + sum(tgs2.puntreturntds) + sum(tgs2.kickreturntds) + sum(tgs2.deftds) as TD,
	sum(tgs2.fieldgoalsmade) as FG,
	sum(tgs2.xpsmade) as XP1,
	sum(tgs2.points) as Points,
    sum(tgs2.points) / (sum(tgs2.rushatts) + sum(tgs2.passatts)) as "Points/Play",
	round(sum(tgs2.points) / count(distinct game.gameid), 2) as "Points/Game" 
from teamgamestat AS tgs1 
    join teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
    join game as game ON tgs1.gameid = game.gameid
    join team as team1 on team1.teamid = tgs1.teamid
    join conference as conference on conference.conferenceid = team1.conferenceid
where
	game.year = :year and
	conference.division = 'FBS'
group by
	team1.teamid
) as teamdefense
where
	teamdefense.teamid = :teamid
