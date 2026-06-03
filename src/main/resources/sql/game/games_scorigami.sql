-- Scorigami
-- This is a unique scorigami, i.e. the score has only happened once. 
-- Technically a scorigami is any game score that has happened.
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
	away.teamid as VisitorTeamId,
	game.homescore + game.awayscore as Points
from game
	join team as away on away.teamid = game.awayteamid
    join team as home on home.teamid = game.hometeamid
group by
	-- winner score
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore), 
	-- loser score
	if(game.homescore >= game.awayscore, game.awayscore, game.homescore)
having
	count(*) = 1
order by
	game.date desc;
