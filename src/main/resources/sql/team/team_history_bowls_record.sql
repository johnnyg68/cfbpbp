-- team_history_bowls_record.sql
-- W and L in bowl games
select 
	sum(if(game.winnerteamid = team.teamid, 1, 0)) as W,
	sum(if(game.winnerteamid <> team.teamid, 1, 0)) as L
from
	game
    join team on team.teamid = game.hometeamid or team.teamid = game.awayteamid
where
    game.bowl <> '' and
    team.teamid = :teamid