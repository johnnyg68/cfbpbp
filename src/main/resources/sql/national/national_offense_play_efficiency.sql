-- national_offense_play_efficiency.sql
-- Single-pass rewrite: all_plays is read once (game-first via idx_year -> idx_gameid),
-- and the per-team metrics are computed in one GROUP BY using 1/0 flag columns,
-- instead of 5 separate aggregations LEFT JOINed back together on the team name.
with all_plays as (
    select
        play.offenseteamid,
        play.playstatyardage,
        play.down,
        play.distance,
        -- offensive success: gained enough for the down's threshold
        case
            when play.down = 1        then play.playstatyardage >= play.distance * .5
            when play.down = 2        then play.playstatyardage >= play.distance * .7
            when play.down in (3, 4)  then play.playstatyardage >= play.distance
            else 0
        end as is_success,
        -- standard down?
        (play.down = 1
            or (play.down = 2 and play.distance <= 6)
            or (play.down >= 3 and play.distance <= 4)) as is_standard,
        -- passing down?
        ((play.down = 2 and play.distance >= 7)
            or (play.down >= 3 and play.distance >= 5)) as is_passing,
        (play.playstatyardage >= 20) as is_explosive
    from play
    join game on game.gameid = play.gameid
    where
        game.year = :year
        and play.playtypeid in (5, 24, 67, 3, 9, 7, 68, 26)
        and play.down > 0
),
team_eff as (
    select
        offenseteamid                    as teamid,
        count(*)                         as total_plays,
        sum(is_standard)                 as std_count,
        sum(is_standard and is_success)  as std_success,
        sum(is_passing)                  as pass_count,
        sum(is_passing and is_success)   as pass_success,
        sum(is_success)                  as all_success,
        sum(is_explosive)                as explosive
    from all_plays
    group by offenseteamid
)
select
    row_number() over (order by te.all_success / nullif(te.total_plays, 0) desc) as "#",
    team.name                                                   as Team,
    te.teamid                                                   as "TeamId",
    te.total_plays                                              as "Total Plays",
    concat(te.std_success, "/", te.std_count)                   as "Success / Standard Downs",
    round(te.std_success  / nullif(te.std_count, 0)   * 100, 1) as "Standard Downs Success %",
    concat(te.pass_success, "/", te.pass_count)                 as "Success / Passing Downs",
    round(te.pass_success / nullif(te.pass_count, 0)  * 100, 1) as "Passing Downs Success %",
    concat(te.all_success, "/", te.total_plays)                 as "Success / All Downs",
    round(te.all_success  / nullif(te.total_plays, 0) * 100, 1) as "All Downs Success %",
    te.explosive                                                as Explosive
from team_eff te
join team on team.teamid = te.teamid
join conference on conference.conferenceid = team.conferenceid
where conference.division = 'fbs'
