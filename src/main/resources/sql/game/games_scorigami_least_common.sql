-- Scorigami least common scores
select
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore) as "Winner Score",
	if(game.homescore >= game.awayscore, game.awayscore, game.homescore) as "Loser Score",
	date_format(game.date, "%m-%d-%Y") as "Date",
	game.gameid,
    count(*) as "Games"
from game 
group by
	-- winner score
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore),
    -- loser score
    if(game.homescore >= game.awayscore, game.awayscore, game.homescore)
order by
	count(*) asc, game.date desc
limit 10;