-- team_total_down_success_rate_aggregate.sql
-- Fast keyed read of the precomputed teamdownsuccess table for one team & season.
-- Returns the team's Offense and Defense rows (replaces the live aggregation in
-- team_total_down_success_rate.sql). Params: :teamid, :year.

select
    teamid,
    side                 as Team,
    allsuccessrate       as 'All Plays Success%',
    stdsuccessrate       as 'Standard Downs Success%',
    passingsuccessrate   as 'Passing Downs Success%',
    allrank              as 'All Ranking',
    stdrank              as 'Standard Ranking',
    passingrank          as 'Pass Ranking'
from teamdownsuccess
where teamid = :teamid
  and year   = :year
order by field(side, 'Offense', 'Defense');   -- Offense first, then Defense
