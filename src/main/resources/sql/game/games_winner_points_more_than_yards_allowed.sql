-- the Rutger (Points > Yards allowed)
select 
	game.gameid as GameId,
    date_format(game.date, "%m-%d-%Y") as Date, 
    team1.teamid as 'WinnerId',
    team1.name as Winner,
    tgs1.points as Points, 
    team2.name as Rutger,
    team2.teamid as 'LoserId',
    tgs2.rushyards as 'Rush Yards',
    tgs2.passyards as 'Pass Yards',
    tgs2.rushyards + tgs2.passyards as 'Total Yards'
from
	teamgamestat as tgs1
	join teamgamestat as tgs2 on tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
	join game as game on game.gameid = tgs1.gameid
	join team as team1 on team1.teamid = tgs1.teamid
    join team as team2 on team2.teamid = tgs2.teamid
where
	tgs1.points > (tgs2.rushyards + tgs2.passyards) and
    (tgs2.rushatts + tgs2.passatts <> 0) 
order by game.gameid asc;