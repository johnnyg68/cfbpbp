-- A team's offense averages grouped by year
SELECT 
	-- team.teamid as 'TeamId',
    game.year as 'Year',
    rankrecord.Ranking as 'AP Rank',
    rankrecord.record as Record,
    ROUND(SUM(tgs.rushyards) / SUM(tgs.rushatts), 2) as 'Rush Yards/Att',
    ROUND(SUM(tgs.rushyards) / COUNT(distinct game.gameid), 2) as 'Rush Yards/G',
    ROUND(SUM(tgs.passyards) / SUM(tgs.passatts), 2) as 'Pass Yards/Att',
    ROUND(SUM(tgs.passyards) / COUNT(distinct game.gameid), 2) as 'Pass Yards/G',
	ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / (SUM(tgs.rushatts) + SUM(tgs.passatts)), 2) as 'Yards/Play',
	ROUND((SUM(tgs.rushyards) + SUM(tgs.passyards)) / COUNT(DISTINCT game.gameid), 2) as 'Yards/G',
    ROUND(SUM(tgs.points) / count(distinct game.gameid), 2) as 'Points/G'
FROM
   teamgamestat as tgs
JOIN team ON team.teamid = tgs.teamid
JOIN game ON game.gameid = tgs.gameid
JOIN conference ON conference.conferenceid = team.conferenceid
JOIN 
	(select 
		t.year as Year, 
		if(isnull(poll.ranking), 'NR', poll.ranking) as Ranking,
		t.record as Record
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
	order by t.year asc) as rankrecord ON rankrecord.year = game.year
WHERE
  conference.division = 'FBS' and
  tgs.teamid = :teamid and
  tgs.rushatts > 0
GROUP BY tgs.teamid, game.year, rankrecord.ranking, rankrecord.record
ORDER BY ROUND(SUM(tgs.points) / count(distinct tgs.gameid), 2) desc
