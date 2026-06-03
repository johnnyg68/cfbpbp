-- defense play efficiency
with all_plays as (
	select
		if(play.defenseteamid = away.teamid, away.name, home.name) as Team,
		play.defenseteamid,
		play.playstatyardage,
		play.down,
		play.distance,
		play.playtypeid
	from play
	join game on game.gameid = play.gameid
	join team as home on home.teamid = game.hometeamid 
	join team as away on away.teamid = game.awayteamid
	where 
		game.year = :year and
		play.playtypeid in (5, 24, 67, 3, 9, 7, 68, 26) and 
		play.down > 0 
),
play_count as (
	select all_plays.Team, 
	all_plays.defenseteamid, 
	count(*) as total_plays
	from all_plays
	group by all_plays.Team, all_plays.defenseteamid 
),
fbs_teams as (
	select distinct all_plays.defenseteamid
	from all_plays
	join team on team.teamid = all_plays.defenseteamid 
    join conference on conference.conferenceid = team.conferenceid 
    where conference.division = 'fbs'
),
standard_downs as (
	select all_plays.team,
	count(*) as count,
	sum(
	case when all_plays.down = 1 then 
		if(all_plays.playstatyardage < all_plays.distance * .5, 1, 0) 
	when all_plays.down = 2 then  
		if(all_plays.playstatyardage < all_plays.distance * .7, 1, 0) 
	when all_plays.down = 3 or all_plays.down = 4 then 
		if(all_plays.playstatyardage < all_plays.distance, 1, 0)
	else 0
	end
	) as Successful
	from all_plays 
	where 
		all_plays.down = 1 or
		(all_plays.down = 2 and all_plays.distance <= 6) or 
		(all_plays.down >= 3 and all_plays.distance <= 4)
	group by all_plays.Team
),
passing_downs as (
	select all_plays.Team,
	count(*) as count,
	sum(
		case 
		when all_plays.down = 2 then  
			if(all_plays.playstatyardage < all_plays.distance * .7, 1, 0) 
		when all_plays.down = 3 or all_plays.down = 4 then 
			if(all_plays.playstatyardage < all_plays.distance, 1, 0)
		else 0
		end
	) as Successful
	from all_plays 
	where 
		(all_plays.down = 2 and all_plays.distance >= 7) or 
		(all_plays.down >= 3 and all_plays.distance >= 5)
	group by all_plays.Team
),
successful_plays as (
	select all_plays.Team,
	sum(
		case when all_plays.down = 1 then 
			if(all_plays.playstatyardage < all_plays.distance * .5, 1, 0) 
		when all_plays.down = 2 then  
			if(all_plays.playstatyardage < all_plays.distance * .7, 1, 0) 
		when all_plays.down = 3 or all_plays.down = 4 then 
			if(all_plays.playstatyardage < all_plays.distance, 1, 0)
		else 0
		end
	) as Successful
	from all_plays
	group by all_plays.Team
),
explosive_plays as (
	select all_plays.Team, 
	count(*) as Explosive
	from all_plays
	where all_plays.playstatyardage >= 20 -- using yardage to identify explosive plays
	group by all_plays.Team
)
select
	row_number() over (order by (successful_plays.Successful / play_count.total_plays) desc) as "#",
	play_count.Team, 
	play_count.defenseteamid as "TeamId",
	play_count.total_plays as "Total Plays",
	concat(standard_downs.Successful, "/", standard_downs.count) as "Success / Standard Downs",
	round(standard_downs.Successful / standard_downs.count * 100, 1) as "Standard Downs Success %",
	concat(passing_downs.Successful, "/", passing_downs.count) as "Success / Passing Downs",
	round(passing_downs.Successful / passing_downs.count * 100, 1) as "Passing Downs Success %",
	concat(successful_plays.Successful, "/", play_count.total_plays) as "Success / All Downs",
	round(successful_plays.Successful / play_count.total_plays * 100, 1) as "All Downs Success %",
	ifnull(explosive_plays.Explosive, 0) as Explosive
from play_count
left join standard_downs on standard_downs.Team = play_count.Team
left join passing_downs on passing_downs.Team = play_count.Team
left join successful_plays on successful_plays.Team = play_count.Team
left join explosive_plays on explosive_plays.Team = play_count.Team
join fbs_teams on fbs_teams.defenseteamid = play_count.defenseteamid 
