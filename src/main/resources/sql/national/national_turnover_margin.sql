-- National Turnover Margin
-- includes AP Rank and W-L record

SELECT 
    @row:=@row + 1 AS '#',
    t.name as Team,
    t.teamid as TeamId,
    IFNULL(t.APRANK, "NR") as "AP Rank",
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
    t.Games as Games,
    t.fumbleslost as 'Fumbles Lost',
    t.intsthrown as 'Ints Thrown',
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
    ap_poll.ranking as APRANK, 
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
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
where
	game.year = :year and
    conf.division = 'FBS' 
group by
	team.name, team.teamid, ap_poll.ranking
order by
	round((sum(tgs2.turnovers) - sum(tgs1.turnovers)) / count(distinct game.gameid), 2) desc) as t
	        CROSS JOIN
    (SELECT @row:=0) AS r
