-- National Offense 3rd Down Conversion
-- includes AP Poll and W-L Record

SELECT 
    row_number() over (order by t.Pct desc) as '#',
	t.Name as Team,
	t.TeamId as TeamId,
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
	t.Games as Games,
	t.Atts as Atts,
	t.Convs as Convs,
	t.Pct as Pct
from (
select
	team.name as Name,
	team.teamid as TeamId,
    ap_poll.ranking as APranking,    
	count(distinct game.gameid) as Games,
	sum(tgs.thirddownatts) as Atts,
	sum(tgs.thirddownconvs) as Convs,
	round(sum(tgs.thirddownconvs) / sum(tgs.thirddownatts) * 100, 2) as Pct
from teamgamestat as tgs
	join team as team on team.teamid = tgs.teamid 
	join game as game on game.gameid = tgs.gameid
	join conference on conference.conferenceid = team.conferenceid
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
where
	game.year = :year and
	conference.division = 'FBS'
group by
	team.name, team.teamid, ap_poll.ranking
) as t

	
	