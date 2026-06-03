-- game/game_preview_game_hisory.sql
-- Game History for Game Preview

select 
	date_format(game.date, "%m-%d-%Y") as Date,
	game.year as Year,
	game.gameid as "GameId",
	game.winnerteamid as "WinnerTeamId",
	if(game.winnerteamid = team1.teamid, team1.name, team2.name) as "Winner",
	game.hometeamid as "HomeTeamId", 
	if(game.hometeamid = team1.teamid, 
		concat(team1.name, " (", v1.Wins, "-", v1.Losses, ")"), 
		concat(team2.name, " (", v2.Wins, "-", v2.Losses, ")")) as "Home",
	game.homescore as "Home Score",
	game.awayteamid as "AwayTeamId",
	if(game.awayteamid = team2.teamid, 
		concat(team2.name, " (", v2.Wins, "-", v2.Losses, ")"), 
		concat(team1.name, " (", v1.Wins, "-", v1.Losses, ")")) as "Visitor",
	game.awayscore as "Visitor Score"
from game 
join team as team1 on team1.teamid = game.hometeamid or team1.teamid = game.awayteamid
join team as team2 on team2.teamid = game.hometeamid or team2.teamid = game.awayteamid
join vyearteamrecord as v1 on v1.year = game.year and team1.teamid = v1.TeamId
join vyearteamrecord as v2 on v2.year = game.year and team2.teamid = v2.TeamId 
where
	(team1.teamid = :awayteamid) and 
	(team2.teamid = :hometeamid)
order by 
	game.date asc;