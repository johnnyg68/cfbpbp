-- Boxscore metadata
select 
	date_format(game.date, "%m-%d-%Y") as Date,
	game.year as Year,
	game.week as Week,
	game.site as Site,
	hometeam.teamid as 'HomeTeamId',
	hometeam.name as 'HomeTeamName',
	hometeam.abbreviation as 'HomeTeamAbbreviation',
	awayteam.teamid as 'VisitorTeamId',
	awayteam.name as 'VisitorTeamName',
	awayteam.abbreviation as 'VisitorTeamAbbreviation',
	concat(awayteam.name, " at ", hometeam.name, " ", date_format(game.date, "%m-%d-%Y")) as Title,
	if(game.bowl != "", game.bowl, "") as Bowl,
	concat(if(game.awayteamrank > 0, concat("#", game.awayteamrank, " ", awayteam.name), awayteam.name), " " , awayteam.mascot, " (", game.awayrecord, ")") as Visitor,
	game.awayscore as 'VisitorScore',
	concat(if(game.hometeamrank > 0, concat("#", game.hometeamrank, " ", hometeam.name), hometeam.name), " ", hometeam.mascot, " (", game.homerecord, ")") as Home,
	game.homescore as 'HomeScore'
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
	game.gameid = ?
	