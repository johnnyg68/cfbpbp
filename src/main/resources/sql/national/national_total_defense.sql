-- Total Team Defense
-- includes AP Rank and W-L record

SELECT 
    @row:=@row + 1 AS '#',
    t.name AS 'Team',
    t.teamid AS 'TeamId',
    IFNULL(t.ranking, "NR") as "AP Rank",
    (select 
		concat(
			count(CAST(case when game.winnerteamid = team.teamid then 1 end as CHAR)), 
			CAST(' - ' as CHAR), 
			count(CAST(case when game.winnerteamid <> team.teamid then 1 end as CHAR))
		) 
	from team 
		join game on team.teamid = game.hometeamid or team.teamid = game.awayteamid  
	where 
		team.teamid = t.teamid and 
		game.year = :year
	group by 
		game.year) as 'Record',
    t.games AS 'Games',
    t.rushatt AS 'Rush Atts',
    t.rushyard AS 'Rush Yards',
    t.passatt AS 'Pass Atts',
    t.passyard AS 'Pass Yards',
    t.play AS 'Plays',
    t.totalyard AS 'Total Yards',
    t.yardsperplay as 'Yards/Play',
	t.yardspergame as 'Yards/G'
FROM (
select 
	team1.name,
	team1.teamid,
    ap_poll.ranking as ranking,
	count(distinct game.gameid) as games,
	sum(tgs2.rushatts) as 'rushatt',
	sum(tgs2.rushyards) as 'rushyard',
	sum(tgs2.passatts) as 'passatt',
	sum(tgs2.passyards) as 'passyard',
	sum(tgs2.rushatts) + sum(tgs2.passatts) as play, 
	sum(tgs2.rushyards) + sum(tgs2.passyards) as totalyard,
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / (sum(tgs2.rushatts) + sum(tgs2.passatts)), 2) as yardsperplay,
    round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / count(distinct game.gameid), 2) as yardspergame
from teamgamestat AS tgs1 
    INNER JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid
    LEFT JOIN game as game ON tgs1.gameid = game.gameid
    INNER JOIN team as team1 on team1.teamid = tgs1.teamid
    INNER JOIN team as team2 on team2.teamid = tgs2.teamid
    join conference as conference on conference.conferenceid = team1.conferenceid
    left join ap_poll on ap_poll.teamid = team1.teamid and ap_poll.year = game.year
where
	game.year = :year and
    tgs1.points <> tgs2.points and
    conference.division = 'FBS'
group by
	team1.name,
	team1.teamid,
    ap_poll.ranking
order by 
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / count(distinct game.gameid), 2)
    ) as t
CROSS JOIN
    (SELECT @row:=0) AS r