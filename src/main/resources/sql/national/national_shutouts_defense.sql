-- shutouts by defense by year

select 
	game.year Year, 
    count(*) as Shutouts, 
    game.winnerteamid as teamid, 
    team.name as Team
from
	game
    join team on team.teamid = game.winnerteamid
    join conference on conference.conferenceid = team.conferenceid
where
	(game.homescore = 0 or game.awayscore = 0) and
    conference.division = "FBS"
group by
	game.year, team.name
order by
	game.year, team.name;