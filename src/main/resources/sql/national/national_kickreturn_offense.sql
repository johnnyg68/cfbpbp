-- National team kick return offense
-- includes AP ranking and W-L record

SELECT 
    row_number() over (order by t.avg desc) as '#',
    t.name as Team,
    t.teamid as TeamId,
    IFNULL(t.APranking, "NR") as "AP ranking",
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
    t.games as Games,
    t.No as No,
    t.yards as Yards,
    t.long as "Long",
	t.td as "TD",
	t.avg as Avg
FROM 
(select 
	team.name as name,
	team.teamid as teamid,
    ap_poll.ranking as APranking,
	COUNT(DISTINCT game.gameid) AS games,
    sum(tgs.kickreturns) as "No",
    sum(tgs.kickreturnyards) as yards,
    round(sum(tgs.kickreturnyards) / sum(tgs.kickreturns), 2) as avg,
    max(tgs.kickreturnlong) as "long",
    sum(tgs.kickreturntds) as "td" 
from teamgamestat as tgs
	join team on team.teamid = tgs.teamid
	join game on game.gameid = tgs.gameid
	join conference on conference.conferenceid = team.conferenceid
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
where 
	game.year = :year and
	conference.division = 'FBS'
group by 
	team.name,
	team.teamid,
    ap_poll.ranking
) AS t

