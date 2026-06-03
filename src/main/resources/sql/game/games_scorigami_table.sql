-- Scorigami table 
 select
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore) as "winner",
	if(game.homescore >= game.awayscore, game.awayscore, game.homescore) as "loser",
    count(*) as "games"
 from game 
 group by
	-- winner score
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore),
    -- loser score
    if(game.homescore >= game.awayscore, game.awayscore, game.homescore)
 order by
	if(game.homescore >= game.awayscore, game.homescore, game.awayscore);

-- this works to get scorigami with both game & gamehistory tables
-- select 
--	if(game.homescore >= game.awayscore, game.homescore, game.awayscore) as "winner",
--	if(game.homescore >= game.awayscore, game.awayscore, game.homescore) as "loser",
--	count(*)
-- from game 
-- group by winner, loser
-- union 
-- select
--	if(gh.homescore >= gh.awayscore, gh.homescore, gh.awayscore) as "winner",
--	if(gh.homescore >= gh.awayscore, gh.awayscore, gh.homescore) as "loser",
--	count(*)
-- from gamehistory as gh
-- group by winner, loser
-- order by winner desc;
  