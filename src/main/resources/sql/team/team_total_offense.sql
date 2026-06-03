-- Team total offense
select teamstats.* from
(SELECT 
   row_number() over (order by t.YardsPerGame desc) as '#',
    t.teamid as "TeamId",
    t.G as Games,
    t.RushYards as 'Rush Yards',
    t.PassYards as 'Pass Yards',
    t.Plays as Plays,
    t.TotalYards as 'Total Yards',
    t.YardsPerPlay AS 'Yards/Play',
    t.YardsPerGame AS 'Yards/G'
FROM
    (SELECT 
       		team.teamid,
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
    WHERE
        game.year = :year AND 
        conference.division = 'FBS'
    GROUP BY team.teamid
) AS t
) as teamstats
where teamstats.teamid = :teamid
