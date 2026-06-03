-- MAX loser score for scorigami
select max(if(game.homescore >= game.awayscore, game.awayscore, game.homescore)) as "max_loser_score"
from game; 

-- select max(max_loser_score) from
-- (select max(if(game.homescore >= game.awayscore, game.awayscore, game.homescore)) as "max_loser_score"
-- from game
-- union
-- select max(if(gh.homescore >= gh.awayscore, gh.awayscore, gh.homescore)) as "max_loser_score"
-- from gamehistory gh) as games ; 