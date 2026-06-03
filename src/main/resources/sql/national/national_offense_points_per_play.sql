-- Offense points/play and yards/play using teamgamestat Rush Atts and Pass Atts
SELECT 
    row_number() over (order by t.PointsPerPlay desc) as '#',
    t.name as Team,
    t.teamid as TeamId,
    ifnull(t.ranking, "NR") as 'AP Ranking',
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
    t.Plays,
    t.Yards,
    t.Points,
    t.YardsPerPlay as 'Yards/Play',
    t.PointsPerPlay as 'Points/Play'
from (
	select 
		team.name,
		team.teamid,
        ap_poll.ranking,
    	sum(tgs.rushatts) + sum(tgs.passatts) as 'Plays',
    	sum(tgs.rushyards) + sum(tgs.passyards)  as 'Yards',
    	sum(tgs.points) as 'Points',
    	(sum(tgs.rushyards) + sum(tgs.passyards)) / (sum(tgs.rushatts) + sum(tgs.passatts)) as 'YardsPerPlay',
    	sum(tgs.points) / (sum(tgs.rushatts) + sum(tgs.passatts)) as 'PointsPerPlay'
	from
		teamgamestat as tgs
    	join game on game.gameid = tgs.gameid 
    	join team on team.teamid = tgs.teamid
        left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
    	join conference as conf on conf.conferenceid = team.conferenceid
	where
		game.year = :year and
    	conf.division = 'FBS'
	group by
		team.teamid
) as t