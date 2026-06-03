-- game_winner_fcs_vs_ranked_fbs.sql
select   
	game.year as Year,
	date_format(game.date, "%m-%d-%Y") as Date,
	concat(if(game.awayteamrank > 0, concat("#", game.awayteamrank, " ", away.name), away.name), " (", game.awayrecord, ")") as Visitor,
	game.awayscore as 'Visitor Score',
	concat(if(game.hometeamrank > 0, concat("#", game.hometeamrank, " ", home.name), home.name), " (", game.homerecord, ")") as Home,
	game.homescore as 'Home Score',
	game.gameid as GameId,
	home.teamid as HomeTeamId,
	away.teamid as VisitorTeamId
from game
join team as home on home.teamid = game.hometeamid
join team as away on away.teamid = game.awayteamid
join conference as homeconf on homeconf.conferenceid = home.conferenceid
join conference as awayconf on awayconf.conferenceid = away.conferenceid
where 
	((homeconf.division = 'FCS' and awayconf.division = 'FBS') or
    (homeconf.division = 'FBS' and awayconf.division = 'FCS')) and
    ((game.hometeamrank > 0 and game.hometeamid <> game.winnerteamid) or
    (game.awayteamrank > 0 and game.awayteamid <> game.winnerteamid)) or
    game.gameid = 272440130
order by
	game.date asc;