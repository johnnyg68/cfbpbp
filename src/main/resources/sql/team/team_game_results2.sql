select 
	date_format(game.date, "%m-%d-%Y") as Date,
	concat(if(game.awayteamrank > 0, concat("#", game.awayteamrank, " ", awayteam.name), awayteam.name), " " , awayteam.mascot, " (", game.awayrecord, ")") as Visitor,
	game.awayscore as 'VisitorScore',
	concat(if(game.hometeamrank > 0, concat("#", game.hometeamrank, " ", hometeam.name), hometeam.name), " ", hometeam.mascot, " (", game.homerecord, ")") as Home,
	game.homescore as 'HomeScore',
    if(game.bowl = "", "", game.bowl) as Bowl
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
	game.year = ? and
	(game.hometeamid = ? or game.awayteamid = ?)
order by
	game.date asc;