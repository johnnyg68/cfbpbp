-- Most common scores
select
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore) as "Winner Score",
	if(game.homescore >= game.awayscore, game.awayscore, game.homescore) as "Loser Score",
    count(*) as "Games"
from game 
group by
	-- winner score
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore),
    -- loser score
    if(game.homescore >= game.awayscore, game.awayscore, game.homescore)
order by
	count(*) desc
limit 10;