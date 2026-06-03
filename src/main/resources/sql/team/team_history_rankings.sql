-- team history ranking and AP rank
select 
	t.year as Year, 
    t.record as Record,
	if(isnull(poll.ranking), 'NR', poll.ranking) as 'AP Rank',
    spr.teamranking as 'SP+ Team Rank',
    spr.oranking as 'SP+ Off Rank',
    spr.dranking as 'SP+ Def Rank'
from
	(select distinct
    	team.teamid,
		game.year,
        cast(concat(
			sum(if(game.winnerteamid = team.teamid, 1, 0)), 
			'-', 
			sum(if(game.winnerteamid <> team.teamid, 1, 0))) as char) as record
	from
		team
    	join game on (team.teamid = game.hometeamid or team.teamid = game.awayteamid)
	where
		team.teamid = :teamid
	group by
		game.year) as t
left join ap_poll as poll on t.teamid = poll.teamid and t.year = poll.year
left join sprating as spr on spr.teamid = t.teamid and spr.year = t.year
order by t.year asc;