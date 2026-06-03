-- game/gamepreview_defense_stats.sql
-- defense for a given tema for gamepreview.html

select 
	team1.name as "Team",
	team1.teamid as "TeamId",
	round(sum(tgs2.points) / count(DISTINCT game.gameid), 2) as "Points/G",	
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / count(DISTINCT game.gameid), 2)  as "Yards/G",
	round((sum(tgs2.rushyards) + sum(tgs2.passyards)) / (sum(tgs2.rushatts) + SUM(tgs2.passatts)), 2) as "Yards/Play",
	round((sum(tgs2.rushatts) + sum(tgs2.passatts)) / count(DISTINCT game.gameid), 2) as "Plays/G",
	round(sum(tgs2.rushyards) / count(DISTINCT game.gameid), 2) as "Rush Yards/G",
	round(sum(tgs2.rushatts) / count(DISTINCT game.gameid), 2) as "Rush Atts/G",
	round(sum(tgs2.rushyards) / sum(tgs2.rushatts), 2) as "Rush /Att Avg",
	round(sum(tgs2.passyards) / count(DISTINCT game.gameid), 2) as "Pass Yards/G",
	round(sum(tgs2.passatts) / count(DISTINCT game.gameid), 2) as "Pass Atts/G",
	round(sum(tgs2.passyards) /sum(tgs2.passatts), 2) as "Pass Yards/Att",
	round(sum(tgs1.tacklesforloss) / count(distinct game.gameid), 2) as "Tackles for Loss/G",
	round(sum(tgs1.sacks) / count(distinct game.gameid), 2) as "Sacks/G",
	round(sum(tgs1.defints) / count(distinct game.gameid), 2) as "Interceptioins/G"
from teamgamestat AS tgs1 
    JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
    JOIN game as game ON tgs1.gameid = game.gameid
    JOIN team as team1 on team1.teamid = tgs1.teamid
where
	game.year = :year and 
	team1.teamid = :teamid
group by
	team1.teamid;