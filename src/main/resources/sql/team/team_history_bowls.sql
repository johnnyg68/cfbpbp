-- team bowl history
select
	game.year as Year,
	UCASE(game.bowl) as Bowl,
    if(hometeam.teamid = :teamid, 
		if(game.hometeamrank > 0, 
			concat('#', game.hometeamrank, ' ', hometeam.name, ' (', game.homerecord, ')'),
            concat(hometeam.name, ' (', game.homerecord, ')')),
        if(game.awayteamrank > 0, 
			concat('#', game.awayteamrank, ' ', awayteam.name, ' (', game.awayrecord, ')'), 
            concat(awayteam.name, ' (', game.awayrecord, ')')
	)) as 'Team',        
	if(hometeam.teamid = :teamid, 
		if(game.awayteamrank > 0, 
			concat("#",game.awayteamrank, " ", awayteam.name, " (", game.awayrecord, ")"), concat(awayteam.name, " (", game.awayrecord, ")")), 
			concat(
				if(game.hometeamrank > 0, 
					concat("#",game.hometeamrank, " ", hometeam.name, " (", game.homerecord, ")"), 
					concat(hometeam.name, " (" , game.homerecord, ")")))) as 'Opponent',
	case when 
		hometeam.teamid = :teamid
    then
		if(game.homescore > game.awayscore, concat("W ", game.homescore, " - ", game.awayscore), concat("L ", game.homescore, " - ", game.awayscore))
    else
		if(game.homescore < game.awayscore, concat("W ", game.awayscore, " - ", game.homescore), concat("L ", game.awayscore, " - ", game.homescore))
    end as Result,
    game.gameid as 'GameId',
    game.hometeamid as 'HomeTeamId',
    game.awayteamid as 'AwayTeamId'
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
    game.bowl <> '' and
    (game.hometeamid = :teamid or game.awayteamid = :teamid)
order by
	game.date asc;