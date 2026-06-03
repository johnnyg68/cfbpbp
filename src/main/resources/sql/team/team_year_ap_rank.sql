select 
	t.year as Year, 
    t.W,
    t.L,
	if(isnull(poll.ranking), 'NR', poll.ranking) as Rank
from
	(select distinct
    	-- team.name,
    	team.teamid,
		game.year,
		sum(if(game.winnerteamid = team.teamid, 1, 0)) as W,
		sum(if(game.winnerteamid <> team.teamid, 1, 0)) as L
	from
		team
    	join game on (team.teamid = game.hometeamid or team.teamid = game.awayteamid)
	where
		team.teamid = :teamid and 
		game.year = :year
	group by
		game.year) as t
left join ap_poll as poll on t.teamid = poll.teamid and t.year = poll.year
order by t.year asc;