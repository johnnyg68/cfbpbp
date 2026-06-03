-- Player career receiving by game
select 
	game.year as Year,
	date_format(game.date, '%m-%d-%Y') as Date,
    game.gameid as GameId,
    team.name as Team,
    team.teamid as TeamId,
    if(team.teamid = game.hometeamid, game.awayteamid, game.hometeamid) as OppId, -- https://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/194.png&h=40&w=40
	if(game.site = 'NEUTRAL', '+', 
		 if(team.teamid = game.hometeamid, '', '@')
	) as 'Site',
    case when 
		team.teamid = game.hometeamid
        then
			concat(
                if(game.awayteamrank > 0, concat('#', game.awayteamrank), ''))
		else
			concat(
                if(game.hometeamrank > 0, concat('#', game.hometeamrank), ''))
    end as 'OppRank',
    (select team.name from team where team.teamid = OppId) as 'Opponent',
    case when 
		team.teamid = game.hometeamid
        then
			concat(
				if(team.teamid = game.winnerteamid, 'W ', 'L '),
				' ', game.homescore, ' - ', game.awayscore)
		else
			concat(
				if(team.teamid <> game.winnerteamid, 'L ', 'W '),
				' ', game.awayscore, ' - ', game.homescore)
    end as 'Result',
    sum(pgs.passrecs) as Recs,
    sum(pgs.passrecyards) as Yards,
	round(sum(pgs.passrecyards) / sum(pgs.passrecs), 2) as 'Yards/Rec',
    sum(pgs.passrectds) as TD,
	max(pgs.passreclong) as 'Long'
from playergamestat as pgs
join team on team.teamid = pgs.teamid
join game on game.gameid = pgs.gameid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where
	player.playerid = ? and 
	pgs.passrecs > 0
group by 
	game.year,
	game.date,
    game.gameid, 
	player.playerid,
    team.teamid,
    OppId
order by
	game.date asc