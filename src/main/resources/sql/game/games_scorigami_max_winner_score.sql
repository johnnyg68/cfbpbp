-- MAX winning score for scorigami
select max(if(game.homescore >= game.awayscore, game.homescore, game.awayscore)) as "max_winner_score"
from game;

-- select max(max_winner_score) from
-- (select max(if(game.homescore >= game.awayscore, game.homescore, game.awayscore)) as "max_winner_score"
-- from game
-- union
-- select max(if(gh.homescore >= gh.awayscore, gh.homescore, gh.awayscore)) as "max_winner_score"
-- from gamehistory as gh) as games;