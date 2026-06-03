-- get games by winner/loser scores
select
	date_format(game.date, "%m-%d-%Y") as Date,
    if(game.homescore >= game.awayscore, game.hometeamid, game.awayteamid) as "WinnerId",
    if(game.homescore >= game.awayscore, home.name, away.name) as "Winner",
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore) as "Winner Score",
    if(game.homescore <= game.awayscore, game.hometeamid, game.awayteamid) as "LoserId",
    if(game.homescore <= game.awayscore, home.name, away.name) as "Loser",
	if(game.homescore >= game.awayscore, game.awayscore, game.homescore) as "Loser Score",
	game.gameid as GameId,
	home.teamid as HomeTeamId,
	away.teamid as VisitorTeamId
from game
	join team as away on away.teamid = game.awayteamid
    join team as home on home.teamid = game.hometeamid
where
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore) = :winner and
    if(game.homescore >= game.awayscore, game.awayscore, game.homescore) = :loser
order by
	game.date desc;