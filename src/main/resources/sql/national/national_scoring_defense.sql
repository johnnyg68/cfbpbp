-- National Scoring Defense
-- includes AP ranking and W-L record
-- includes Points/Play

-- Name	G	TD	FG	1XP	2XP	Safety	Points	Points/G
-- National Scoring Defense
SELECT 
    @row:=@row + 1 AS '#',
    t.name AS 'Team',
    t.teamid as 'TeamId',
    IFNULL(t.ranking, "NR") as "AP ranking",
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
    t.games as 'Games',
    t.tds as 'TDs',
    t.fgs as 'FGs',
    t.xps as 'XP1s',
    t.points as 'Points',
    t.pointsperplay as 'Points/Play',
    t.pointspergame as 'Points/G'
from (    
select 
	team1.name as name,
	team1.teamid as teamid,
    ap_poll.ranking,
	count(distinct game.gameid) as games,
	sum(tgs2.passtds) + sum(tgs2.rushtds) + sum(tgs2.puntreturntds) + sum(tgs2.kickreturntds) + sum(tgs2.deftds) as tds,
	sum(tgs2.fieldgoalsmade) as fgs,
	sum(tgs2.xpsmade) as xps,
	sum(tgs2.points) as points,
    sum(tgs2.points) / (sum(tgs2.rushatts) + sum(tgs2.passatts)) as pointsperplay,
	round(sum(tgs2.points) / count(distinct game.gameid), 2) as pointspergame 
from teamgamestat AS tgs1 
    INNER JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid
    LEFT JOIN game as game ON tgs1.gameid = game.gameid
    INNER JOIN team as team1 on team1.teamid = tgs1.teamid
    INNER JOIN team as team2 on team2.teamid = tgs2.teamid
    join conference as conference on conference.conferenceid = team1.conferenceid
    left join ap_poll on ap_poll.teamid = team1.teamid and ap_poll.year = game.year
where
	game.year = :year and
	conference.division = 'FBS' and
	tgs1.points <> tgs2.points
group by
	team1.name,
	team1.teamid,
    ap_poll.ranking
order by
	sum(tgs2.points) / count(distinct game.gameid) asc
) as t
  CROSS JOIN
    (SELECT @row:=0) AS r

