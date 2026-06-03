-- team history vs opponent
select
    if(hometeam.teamid = :teamid, awayteam.name, hometeam.name) as Team, 
	if(hometeam.teamid = :teamid, awayteam.teamid, hometeam.teamid) as OpponentId,    
    sum(if(game.winnerteamid = :teamid, 1, 0)) as Wins,
    sum(if(game.winnerteamid <> :teamid, 1, 0)) as Losses,
    round(sum(if(game.winnerteamid = :teamid, 1, 0)) / count(distinct game.gameid), 2) as 'Pct',
    null as 'Date',
    null as GameId,
    null as 'ThisTeam',
	null as Opponent,
    null as Result
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
	hometeam.teamid = :teamid or awayteam.teamid = :teamid
group by
    Team,
    OpponentId
UNION    
select
    if(hometeam.teamid = :teamid, awayteam.name, hometeam.name) as Team, 
	if(hometeam.teamid = :teamid, awayteam.teamid, hometeam.teamid) as OpponentId,    
	null as 'Wins',
    null as 'Losses',
    null as 'Pct',
    date_format(game.date, "%m-%d-%Y") as 'Date',
    game.gameid as 'GameId',
    if(hometeam.teamid = :teamid, 
		if(game.hometeamrank > 0, 
			concat('#', game.hometeamrank, ' ', hometeam.name, ' (', game.homerecord, ')'),
            concat(hometeam.name, ' (', game.homerecord, ')')),
        if(game.awayteamrank > 0, 
			concat('#', game.awayteamrank, ' ', awayteam.name, ' (', game.awayrecord, ')'), 
            concat(awayteam.name, ' (', game.awayrecord, ')')
    )) as 'ThisTeam',
    case when
		game.site = 'NEUTRAL'
	then
		concat("+ ", 
        if(hometeam.teamid = :teamid, 
				if(game.awayteamrank > 0, 
					concat("#", game.awayteamrank, " ", awayteam.name, " (", game.awayrecord, ")"), 
                    concat(awayteam.name, " (", game.awayrecord, ")")), 
                 if(game.hometeamrank > 0, 
					concat("#", game.hometeamrank, " ", hometeam.name, " (", game.homerecord, ")"), 
                    concat(hometeam.name, " (", game.homerecord, ")"))))
	else
		if(hometeam.teamid = :teamid, 
			if(game.awayteamrank > 0, 
				concat("#", game.awayteamrank, " ", awayteam.name, " (", game.awayrecord, ")"),
                concat(awayteam.name, " (", game.awayrecord, ")")),
			concat("@ ", 
				if(game.hometeamrank > 0, 
					concat("#", game.hometeamrank, " ", hometeam.name, " (", game.homerecord, ")"), 
                    concat(hometeam.name, " (", game.homerecord, ")"))))
	end as 'Opponent',
	case when 
		hometeam.teamid = :teamid
    then
		if(game.homescore > game.awayscore, 
			concat("W ", game.homescore, " - ", game.awayscore), 
            concat("L ", game.homescore, " - ", game.awayscore))
    else
		if(game.homescore < game.awayscore, 
			concat("W ", game.awayscore, " - ", game.homescore), 
            concat("L ", game.awayscore, " - ", game.homescore))
    end as 'Result'
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
	hometeam.teamid = :teamid or awayteam.teamid = :teamid
order by
	Team asc, Wins desc, GameId asc;