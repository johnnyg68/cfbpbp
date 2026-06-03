-- defense totals by year
select 
	-- team.teamid as 'TeamId',
	game.year as 'Year',
    rankrecord.Ranking as 'AP Rank',
    rankrecord.record as 'Record',
	ROUND(SUM(tgs2.rushyards) / SUM(tgs2.rushatts), 2) as 'Rush Yards/Att',
	ROUND(SUM(tgs2.rushyards) / COUNT(distinct game.gameid), 2) as 'Rush Yards/G',
	ROUND(SUM(tgs2.passyards) / SUM(tgs2.passatts), 2) as 'Pass Yards/Att',
	ROUND(SUM(tgs2.passyards) / COUNT(distinct game.gameid), 2) as 'Pass Yards/G',
	ROUND((SUM(tgs2.rushyards) + SUM(tgs2.passyards)) / (SUM(tgs2.rushatts) + SUM(tgs2.passatts)), 2) as 'Yards/Play',
    ROUND((SUM(tgs2.rushyards) + SUM(tgs2.passyards)) / COUNT(DISTINCT game.gameid), 2) as 'Yards/G',
    ROUND(SUM(tgs2.points) / count(distinct game.gameid), 2) as 'Points/G'
from teamgamestat AS tgs1
    JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
    JOIN game as game ON tgs1.gameid = game.gameid
    JOIN team as team1 on team1.teamid = tgs1.teamid
    JOIN conference as conference on conference.conferenceid = team1.conferenceid
    JOIN 
	(select 
		t.year as Year, 
		if(isnull(poll.ranking), 'NR', poll.ranking) as Ranking,
		t.record as Record
	from
	(select distinct
--     	team.name,
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
where
    conference.division = 'FBS' and
    tgs1.teamid = :teamid and
    tgs2.rushatts > 0
group by
	team1.teamid, game.year, rankrecord.Ranking, rankrecord.record
order by 
	ROUND(SUM(tgs2.points) / count(distinct game.gameid), 2)