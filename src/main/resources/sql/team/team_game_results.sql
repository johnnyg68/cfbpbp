-- Team Schedule including future games
-- Team Game Results
select t.Date, t.Opponent, t.Result, t.GameId, t.HomeTeamId, t.AwayTeamId 
from
(select
	date_format(game.date, '%m-%d-%Y') as Date,
	game.date as sqldate,
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
    end as 'Result',
    game.gameid as 'GameId',
    game.hometeamid as 'HomeTeamId',
    game.awayteamid as 'AwayTeamId'
from
	game
    join team as hometeam on hometeam.teamid = game.hometeamid
    join team as awayteam on awayteam.teamid = game.awayteamid
where
    game.year = :year and
    (game.hometeamid = :teamid or game.awayteamid = :teamid)
union
select 
	date_format(schedule.date, '%m-%d-%Y') as Date,
	schedule.date as sqldate,
	case when schedule.site = "NEUTRAL" 
	then
		concat("+ ", if(hometeam.teamid = :teamid, awayteam.name, hometeam.name))
    else 
    	if(schedule.hometeamid <> :teamid, concat("@ ", hometeam.name), awayteam.name)
    end as Opponent,
	"TBD" as Result,
	schedule.gameid as 'GameId',
	schedule.hometeamid as 'HomeTeamId',
    schedule.awayteamid as 'AwayTeamId'
from
	schedule
	join team as hometeam on hometeam.teamid = schedule.hometeamid
    join team as awayteam on awayteam.teamid = schedule.awayteamid
where
	schedule.complete = 0 and
	schedule.year = :year and 
	(schedule.hometeamid = :teamid or schedule.awayteamid = :teamid)
order by sqldate) as t;