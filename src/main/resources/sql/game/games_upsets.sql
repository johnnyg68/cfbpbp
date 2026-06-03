-- Upsets 

select distinct 
	game.year as Year,
	odds.gameid as GameId, 
	date_format(game.date, "%m-%d-%Y") as Date, 
	game.awayteamid as VisitorTeamId, 
	concat(if(game.awayteamrank > 0, concat("#", game.awayteamrank, " ", away.name), away.name), " (", game.awayrecord, ")") as Visitor,
	game.awayscore as "Visitor Score", 
	game.hometeamid as HomeTeamId, 
	concat(if(game.hometeamrank > 0, concat("#", game.hometeamrank, " ", home.name), home.name), " (", game.homerecord, ")") as Home,
	game.homescore as "Home Score", 
	if(game.awayscore > game.homescore, 
		concat(away.name, " ", odds.spread), 
		concat(home.name, " ", odds.spread)) as Spread
from odds 
join game on game.gameid = odds.gameid 
join team home on home.teamid = game.hometeamid 
join team away on away.teamid = game.awayteamid 
where 
	odds.favoriteid <> game.winnerteamid 
order by odds.spread asc
limit 100;