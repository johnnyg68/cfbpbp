-- ap_poll ranking by year

select 
	poll.ranking as "Rank", 
	team.name as Team, 
	team.teamid as TeamId, 
	poll.record as Record 
from 
	team 
	join ap_poll as poll on poll.teamid = team.teamid 
where 
	poll.year = :year 
order by 
	poll.ranking asc;

-- PROBLEM HERE!!!  Can't get record if team did not play for the given week
-- select distinct 
--	polls.poll as pollname, 
--    polls.year, 
--    polls.rank as 'Rank', 
--    team.teamid, 
--    team.name as 'Team', 
--    if(game.hometeamid = team.teamid, game.homerecord, game.awayrecord) as 'Record',
--    polls.firstplacevotes as 'First Place', 
--    polls.points as 'Points'
-- from polls
-- join team on team.teamid = polls.teamid
-- join game on game.hometeamid = polls.teamid or game.awayteamid = polls.teamid
-- where 
--	game.year = :year and game.week = :week and 
--    polls.week = :week and polls.year = :year
-- order by poll, rank + '0';