-- # Games a team's offense was shutout per year
select 
	game.year Year,
    count(*) "Games Shutout",
	if(game.hometeamid = game.winnerteamid, game.awayteamid, game.hometeamid) teamid,
    team.name Team
from
	game
    join team on team.teamid = if(game.hometeamid = game.winnerteamid, game.awayteamid, game.hometeamid)
    join conference on conference.conferenceid = team.conferenceid
where
	(game.homescore = 0 or game.awayscore = 0) and
    conference.division = "FBS"
group by
	game.year,
	if(game.hometeamid = game.winnerteamid, game.awayteamid, game.hometeamid)
order by
	game.year,
    team.name