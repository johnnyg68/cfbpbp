-- National Rushing Offense
-- includes AP ranking and W-L record

SELECT 
    @row:=@row + 1 AS '#',
    t.name as Team,
    t.teamid as TeamId,
    IFNULL(t.APranking, "NR") as "AP Ranking",
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
    t.Att as Atts,
    t.Yards as Yards,
    t.Avg as Avg,
    t.TD as TDs,
    t.Att_G AS 'Atts/G',
    t.Yards_G AS 'Yards/G'
FROM
    (SELECT 
        team.name,
        team.teamid,
		ap_poll.ranking as APranking,
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
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
    WHERE
        game.year = :year and
        conference.division = 'FBS'
    GROUP BY 
    	team.name,
    	team.teamid,
        ap_poll.ranking
    ORDER BY SUM(tgs.rushyards) / COUNT(DISTINCT game.gameid) DESC) AS t
CROSS JOIN
    (SELECT @row:=0) AS r
LIMIT 0 , 1000;
