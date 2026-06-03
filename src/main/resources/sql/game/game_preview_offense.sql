-- game/game_preview_offense_stats.sql
-- offense stats
-- game preview team offense stats
select 
	team.name as "Team",
	team.teamid as "TeamId",
	round(sum(tgs.points) / count(DISTINCT game.gameid), 2) as "Points/G",	
	round((sum(tgs.rushyards) + sum(tgs.passyards)) / count(DISTINCT game.gameid), 2)  as "Yards/G",
	round((sum(tgs.rushyards) + sum(tgs.passyards)) / (sum(tgs.rushatts) + SUM(tgs.passatts)), 2) as "Yards/Play",
	round((sum(tgs.rushatts) + sum(tgs.passatts)) / count(DISTINCT game.gameid), 2) as "Plays/G",
	round(sum(tgs.rushyards) / count(DISTINCT game.gameid), 2) as "Rush Yards/G",
	round(sum(tgs.rushatts) / count(DISTINCT game.gameid), 2) as "Rush Atts/G",
	round(sum(tgs.rushyards) / sum(tgs.rushatts), 2) as "Rush Yards/Att Avg",
	round(sum(tgs.passyards) / count(DISTINCT game.gameid), 2) as "Pass Yards/G",
	round(sum(tgs.passatts) / count(DISTINCT game.gameid), 2) as "Pass Atts/G",
	round(sum(tgs.passyards) /sum(tgs.passatts), 2) as "Pass Yards/Att",
	round(sum(tgs1.tacklesforloss) / count(distinct game.gameid), 2) as "Tackles for Loss Allowed/G",
	round(sum(tgs1.sacks) / count(distinct game.gameid), 2) as "Sacks Allowed/G",
	round(sum(tgs.passints) / count(distinct game.gameid), 2) as "Interceptions Thrown/G"
FROM
    teamgamestat as tgs
    JOIN teamgamestat AS tgs1 ON tgs.gameid = tgs1.gameid and tgs.teamid <> tgs1.teamid
    JOIN team ON team.teamid = tgs.teamid
    JOIN game ON game.gameid = tgs.gameid
WHERE
	game.year = :year and 
	team.teamid = :teamid
GROUP BY team.teamid

