-- box score 
select 
	team.name as Team, 
	tgs.firstdowns as '1st Downs', 
	concat(tgs.thirddownconvs, ' / ', tgs.thirddownatts) as '3rd Downs',
	concat(tgs.fourthdownconvs, ' / ', tgs.fourthdownatts) as '4th Downs',
	tgs.rushatts + tgs.passatts as 'Total Plays',
	tgs.rushyards + tgs.passyards as 'Total Yards',
	round((tgs.rushyards + tgs.passyards) / (tgs.rushatts + tgs.passatts), 2) as 'Yards/Play',
	tgs.rushyards as 'Rush Yards',
	tgs.rushatts as 'Rush Atts',
	round(tgs.rushyardsavg, 2) as 'Rush Avg',
	tgs.passyards as 'Pass Yards',
	concat(tgs.passcomps, ' / ', tgs.passatts) as 'Comps/Atts',
	round(tgs.passyards / tgs.passatts, 2) as 'Yards/Atts',
	concat(tgs.penalties, ' / ', tgs.penaltyyards) as 'Penalties',
	tgs.turnovers as 'Turnovers',
	tgs.fumbleslost as 'Fumbles Lost',
	tgs.interceptions as 'Interceptions Thrown',
	concat(floor(tgs.timeofpossession / 60), ':', LPAD(tgs.timeofpossession % 60,2,0)) as 'Possession'
from teamgamestat as tgs 
	join team on team.teamid = tgs.teamid
	join game on game.gameid = tgs.gameid
where 
	game.gameid = ?

