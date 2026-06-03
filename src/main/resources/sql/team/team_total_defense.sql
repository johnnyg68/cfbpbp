-- Total Team Defense
select teamstats.* from
(SELECT 
    row_number() over (order by t.yardspergame asc) as '#',
    t.teamid AS 'TeamId',
    t.games AS 'Games',
    t.rushyard AS 'Rush Yards',
    t.passyard AS 'Pass Yards',
    t.play AS 'Plays',
    t.totalyard AS 'Total Yards',
    t.yardsperplay as 'Yards/Play',
	t.yardspergame as 'Yards/G'
FROM (
select 
	team1.teamid,
	count(distinct game.gameid) as games,
	sum(tgs2.rushyards) as 'rushyard',
	sum(tgs2.passyards) as 'passyard',
	sum(tgs2.rushatts) + sum(tgs2.passatts) as play, 
	sum(tgs2.rushyards) + sum(tgs2.passyards) as totalyard,
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / (sum(tgs2.rushatts) + sum(tgs2.passatts)), 2) as yardsperplay,
    round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / count(distinct game.gameid), 2) as yardspergame
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

