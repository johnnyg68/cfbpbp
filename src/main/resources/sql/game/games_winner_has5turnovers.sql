select
	game.year as Year,
	date_format(game.date, "%m-%d-%Y") as Date,
	concat(if(game.awayteamrank > 0, concat("#", game.awayteamrank, " ", awayteam.name), awayteam.name), " (", game.awayrecord, ")") as Visitor,
	game.awayscore as 'Visitor Score',
	concat(if(game.hometeamrank > 0, concat("#", game.hometeamrank, " ", hometeam.name), hometeam.name), " (", game.homerecord, ")") as Home,
	game.homescore as 'Home Score',
	game.gameid as GameId,
	hometeam.teamid as HomeTeamId,
	awayteam.teamid as VisitorTeamId
from
	game
    join teamgamestat as tgs on tgs.gameid = game.gameid
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
	tgs.turnovers >= 5 and
    game.winnerteamid = tgs.teamid
order by
	game.date asc;
