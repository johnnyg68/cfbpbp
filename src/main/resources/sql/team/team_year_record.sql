-- Team Year Record and metadata
select 
	team.teamid as 'TeamId',
	team.name as 'Name', 
	team.mascot as 'Mascot', 
	if(team.teamid = game.hometeamid, game.homerecord, game.awayrecord) as 'Record',
    ap_poll.ranking as 'ranking',
	date_format(game.date, '%m-%d-%Y') as Date,
	team.color as 'Color',
	team.alternatecolor as 'AlternateColor'
from team
	join game on game.hometeamid = team.teamid or game.awayteamid = team.teamid
    left join ap_poll on team.teamid = ap_poll.teamid and game.year = ap_poll.year
where 
	team.teamid = :teamid and
	game.year = :year
order by 
	game.date desc
limit 1;
