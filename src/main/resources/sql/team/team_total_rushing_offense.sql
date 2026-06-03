-- Team Total Rushing Offense
select teamstats.* from
(SELECT 
    row_number() over (order by t.Yards_G desc) as '#',
    t.teamid as TeamId,
    t.G as Games,
    t.Att as Atts,
    t.Yards as Yards,
    t.Avg as Avg,
    t.TD as TD,
    t.Att_G AS 'Atts/G',
    t.Yards_G AS 'Yards/G'
FROM
    (SELECT 
        team.teamid,
        COUNT(DISTINCT game.gameid) AS G,
        SUM(tgs.rushatts) AS Att,
        SUM(tgs.rushyards) AS Yards,
        ROUND(SUM(tgs.rushyards) / SUM(tgs.rushatts), 2) AS Avg,
        SUM(tgs.rushtds) as TD,
        ROUND(SUM(tgs.rushatts) / COUNT(DISTINCT game.gameid), 2) AS Att_G,
        ROUND(SUM(tgs.rushyards) / COUNT(DISTINCT game.gameid), 2) AS Yards_G
    FROM
        teamgamestat as tgs
    JOIN team ON team.teamid = tgs.teamid
    JOIN game ON game.gameid = tgs.gameid
    JOIN conference ON conference.conferenceid = team.conferenceid
    WHERE
        game.year = :year AND 
        conference.division = 'FBS'
    GROUP BY 
    	team.teamid
    ) AS t
) as teamstats
where teamstats.teamid = :teamid
