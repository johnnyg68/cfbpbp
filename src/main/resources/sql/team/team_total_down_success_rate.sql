-- team_total_down_success_rate.sql

with all_plays as (
    select
        play.gameid,
        play.playid,
        play.offenseteamid,
        play.defenseteamid,
        play.playstatyardage,
        play.down,
        play.distance,
        play.playtypeid
    from play
    join game on game.gameid = play.gameid
    where 
        game.year = :year
        and play.playtypeid in (5, 24, 67, 3, 9, 7, 68, 26)
        and play.down > 0
),
offense_stats as (
    select /*+ NO_MERGE(all_plays) */
        offenseteamid as teamid,
        'Offense' as team,
        count(*) as total_plays,
        sum(
            case
                when down = 1 and playstatyardage >= distance * .5 then 1
                when down = 2 and playstatyardage >= distance * .7 then 1
                when down in (3,4) and playstatyardage >= distance then 1
                else 0
            end
        ) as all_successful_plays,
        sum(
        	case
        		when down = 1 then 1
        		when down = 2 and distance <=6 then 1
        		when down in (3,4) and distance <=4 then 1
        		else 0
        	end        	
        ) total_standard_plays,
        sum(
            case
                when down = 1 and playstatyardage >= distance *.5 then 1
                when down = 2 and distance <=6 and playstatyardage >= distance *.7 then 1
                when down in (3,4) and distance <=4 and playstatyardage >= distance then 1
                else 0
            end
        ) as successful_standard_plays,
        sum(
        	case
        		when down = 2 and distance >=7 then 1
        		when down in (3,4) and distance >=5 then 1
        		else 0
        	end
        ) as total_passing_plays,
        sum(
            case
                when down = 2 and distance >=7 and playstatyardage >= distance *.7 then 1
                when down in (3,4) and distance >=5 and playstatyardage >= distance then 1
                else 0
            end
        ) as successful_passing_plays,
        sum(case when playstatyardage >= 20 then 1 else 0 end) as explosive
    from all_plays
    group by offenseteamid
),
offense_ranked as (
    select
        team.teamid,
        team,
        all_successful_plays / nullif(total_plays,0) as 'All Plays Success%',
        successful_standard_plays / nullif(total_standard_plays,0) as 'Standard Downs Success%',
        successful_passing_plays / nullif(total_passing_plays,0) as 'Passing Downs Success%',
        rank() over (order by all_successful_plays / nullif(total_plays,0) desc) as 'All Ranking',
        rank() over (order by successful_standard_plays / nullif(total_standard_plays,0) desc) as 'Standard Ranking',
        rank() over (order by successful_passing_plays / nullif(total_passing_plays,0) desc) as 'Pass Ranking'
    from offense_stats
    join team on team.teamid = offense_stats.teamid
    join conference on conference.conferenceid = team.conferenceid
    where conference.division = 'FBS'
),
defense_stats as (
    select /*+ NO_MERGE(all_plays) */
        defenseteamid as teamid,
        'Defense' as team,
        count(*) as total_plays,
        sum(
            case
                when down = 1 and playstatyardage <= distance * .5 then 1
                when down = 2 and playstatyardage <= distance * .7 then 1
                when down in (3,4) and playstatyardage <= distance then 1
                else 0
            end
        ) as all_successful_plays,
        sum(
        	case
        		when down = 1 then 1
        		when down = 2 and distance <=6 then 1
        		when down in (3,4) and distance <=4 then 1
        		else 0
        	end        	
        ) total_standard_plays,
        sum(
            case
                when down = 1 and playstatyardage <= distance *.5 then 1
                when down = 2 and distance <=6 and playstatyardage <= distance *.7 then 1
                when down in (3,4) and distance <=4 and playstatyardage <= distance then 1
                else 0
            end
        ) as successful_standard_plays,
        sum(
        	case
        		when down = 2 and distance >=7 then 1
        		when down in (3,4) and distance >=5 then 1
        		else 0
        	end
        ) as total_passing_plays,
        sum(
            case
                when down = 2 and distance >=7 and playstatyardage <= distance *.7 then 1
                when down in (3,4) and distance >=5 and playstatyardage <= distance then 1
                else 0
            end
        ) as successful_passing_plays,
        sum(case when playstatyardage >= 20 then 1 else 0 end) as explosive
    from all_plays
    group by defenseteamid
),
defense_ranked as (
    select
        team.teamid,
        team,
        all_successful_plays / nullif(total_plays,0) as 'All Plays Success%',
        successful_standard_plays / nullif(total_standard_plays,0) as 'Standard Downs Success%',
        successful_passing_plays / nullif(total_passing_plays,0) as 'Passing Downs Success%',
        rank() over (order by all_successful_plays / nullif(total_plays,0) desc) as 'All Ranking',
        rank() over (order by successful_standard_plays / nullif(total_standard_plays,0) desc) as 'Standard Ranking',
        rank() over (order by successful_passing_plays / nullif(total_passing_plays,0) desc) as 'Pass Ranking'
    from defense_stats
    join team on team.teamid = defense_stats.teamid
    join conference on conference.conferenceid = team.conferenceid
    where conference.division = 'FBS'
)
select *
from offense_ranked
where teamid = :teamid
union all
select *
from defense_ranked
where teamid = :teamid