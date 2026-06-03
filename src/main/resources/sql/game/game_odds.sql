select
	if(odds.providername is null, odds.providerid, odds.providername) as Book,
    team.name as Favorite,
    odds.details as Spread,
    odds.awaywinpct as "Away Win Pct",
    odds.homewinpct as "Home Win Pct",
    odds.awaymoneyline as "Away Money Line",
    odds.homemoneyline as "Home Money Line",
	odds.overunder as "Over/Under"
from odds 
    join team on team.teamid = odds.favoriteid
where odds.gameid = ?;