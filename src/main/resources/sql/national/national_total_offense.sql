-- National Total Offense
-- includes AP Rank and W/L Record

SELECT 
    @row:=@row + 1 AS '#',
    t.name as Team,
    t.teamid as 'TeamId',
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
    t.G as Games,
    t.RushYards as 'Rush Yards',
    t.PassYards as 'Pass Yards',
    t.Plays as Plays,
    t.TotalYards as 'Total Yards',
    t.YardsPerPlay AS 'Yards/Play',
    t.YardsPerGame AS 'Yards/G'
FROM
    (SELECT 
       		team.name,
       		team.teamid,
            ap_poll.ranking as APRANK,
            COUNT(DISTINCT game.gameid) AS G,
            SUM(tgs.rushyards) AS RushYards,
            SUM(tgs.passyards) as PassYards,
            SUM(tgs.rushatts) + SUM(tgs.passatts) as Plays,
            SUM(tgs.rushyards) + SUM(tgs.passyards) as TotalYards,
			ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / (SUM(tgs.rushatts) + SUM(tgs.passatts)), 2) as YardsPerPlay,
			ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / COUNT(DISTINCT game.gameid), 2) as YardsPerGame
    FROM
        teamgamestat as tgs
    JOIN team ON team.teamid = tgs.teamid
    JOIN game ON game.gameid = tgs.gameid
    JOIN conference ON conference.conferenceid = team.conferenceid
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
    WHERE
        game.year = :year and
        conference.division = 'FBS'
    GROUP BY team.name, team.teamid, ap_poll.ranking
    ORDER BY ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / COUNT(DISTINCT game.gameid), 2) desc) AS t
        CROSS JOIN
    (SELECT @row:=0) AS r
LIMIT 0 , 1000