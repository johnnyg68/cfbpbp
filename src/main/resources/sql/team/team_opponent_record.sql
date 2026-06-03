-- Opponent aggregate W/L record for a given team for a year
select
	sum(all_teams.W) as Wins,
    sum(all_teams.L) as Losses,
    round(sum(all_teams.W) / (sum(all_teams.L) + sum(all_teams.W)), 2) as PCT
from
(select
	team.teamid,
    team.name,
    sum(if(game.winnerteamid = team.teamid, 1, 0)) as W,
    sum(if(game.winnerteamid <> team.teamid, 1, 0)) as L
from
	team
    join game on game.hometeamid = team.teamid or game.awayteamid = team.teamid
where
	game.year = :year
group by
	team.teamid
order by team.teamid) as all_teams
join
(select 
	if(hometeam.teamid <> :teamid, hometeam.teamid, awayteam.teamid) as teamid
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
    game.year = :year and
    (game.hometeamid = :teamid or game.awayteamid = :teamid)) as opponent_ids
on opponent_ids.teamid = all_teams.teamid;
	


