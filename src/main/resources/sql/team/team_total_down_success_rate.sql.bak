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
        -- and (game.hometeamid = :teamid or game.awayteamid = :teamid)
),
-- ================= OFFENSIVE AGGREGATES =================
offense_standard as (
    select 
        offenseteamid as teamid,
        count(*) as total_plays,
        sum(
            case 
                when down = 1 and playstatyardage >= distance * 0.5 then 1
                when down = 2 and playstatyardage >= distance * 0.7 then 1
                when down in (3,4) and playstatyardage >= distance then 1
                else 0
            end
        ) as successful
    from all_plays
    where (down = 1 or (down = 2 and distance <= 6) or (down >= 3 and distance <= 4))
    group by offenseteamid
),
offense_passing as (
    select 
        offenseteamid as teamid,
        count(*) as total_plays,
        sum(
            case 
                when down = 2 and playstatyardage >= distance * 0.7 then 1
                when down in (3,4) and playstatyardage >= distance then 1
                else 0
            end
        ) as successful
    from all_plays
    where (down = 2 and distance >= 7) or (down >= 3 and distance >= 5)
    group by offenseteamid
),
offense_overall as (
    select 
        offenseteamid as teamid,
        count(*) as total_plays,
        sum(
            case 
                when down = 1 and playstatyardage >= distance * 0.5 then 1
                when down = 2 and playstatyardage >= distance * 0.7 then 1
                when down in (3,4) and playstatyardage >= distance then 1
                else 0
            end
        ) as successful,
        sum(case when playstatyardage >= 20 then 1 else 0 end) as explosive
    from all_plays
    group by offenseteamid
),
-- ================= DEFENSIVE AGGREGATES =================
defense_standard as (
    select 
        defenseteamid as teamid,
        count(*) as total_plays,
        sum(
            case 
                when down = 1 and playstatyardage < distance * 0.5 then 1
                when down = 2 and playstatyardage < distance * 0.7 then 1
                when down in (3,4) and playstatyardage < distance then 1
                else 0
            end
        ) as successful
    from all_plays
    where (down = 1 or (down = 2 and distance <= 6) or (down >= 3 and distance <= 4))
    group by defenseteamid
),
defense_passing as (
    select 
        defenseteamid as teamid,
        count(*) as total_plays,
        sum(
            case 
                when down = 2 and playstatyardage < distance * 0.7 then 1
                when down in (3,4) and playstatyardage < distance then 1
                else 0
            end
        ) as successful
    from all_plays
    where (down = 2 and distance >= 7) or (down >= 3 and distance >= 5)
    group by defenseteamid
),
defense_overall as (
    select 
        defenseteamid as teamid,
        count(*) as total_plays,
        sum(
            case 
                when down = 1 and playstatyardage < distance * 0.5 then 1
                when down = 2 and playstatyardage < distance * 0.7 then 1
                when down in (3,4) and playstatyardage < distance then 1
                else 0
            end
        ) as successful,
        sum(case when playstatyardage >= 20 then 1 else 0 end) as explosive
    from all_plays
    group by defenseteamid
),
-- ================= RANKINGS =================
offense_ranked as (
    select 
        o_overall.teamid,
        o_standard.successful / o_standard.total_plays as std_rate,
        o_passing.successful / o_passing.total_plays as pass_rate,
        o_overall.successful / o_overall.total_plays as overall_rate,
        o_overall.explosive / o_overall.total_plays as explosive_rate,
        rank() over (order by o_standard.successful / o_standard.total_plays desc) as std_rank,
        rank() over (order by o_passing.successful / o_passing.total_plays desc) as pass_rank,
        rank() over (order by o_overall.successful / o_overall.total_plays desc) as overall_rank,
        rank() over (order by o_overall.explosive / o_overall.total_plays desc) as explosive_rank
    from offense_standard o_standard
    join offense_passing o_passing on o_passing.teamid = o_standard.teamid
    join offense_overall o_overall on o_overall.teamid = o_standard.teamid
    join team t on t.teamid = o_overall.teamid
    join conference conf on conf.conferenceid = t.conferenceid
    where conf.division = 'FBS'
),
defense_ranked as (
    select 
        d_overall.teamid,
        d_standard.successful / d_standard.total_plays as std_rate,
        d_passing.successful / d_passing.total_plays as pass_rate,
        d_overall.successful / d_overall.total_plays as overall_rate,
        d_overall.explosive / d_overall.total_plays as explosive_rate,
        rank() over (order by d_standard.successful / d_standard.total_plays desc) as std_rank,
        rank() over (order by d_passing.successful / d_passing.total_plays desc) as pass_rank,
        rank() over (order by d_overall.successful / d_overall.total_plays desc) as overall_rank,
        rank() over (order by d_overall.explosive / d_overall.total_plays asc) as explosive_rank
    from defense_standard d_standard
    join defense_passing d_passing on d_passing.teamid = d_standard.teamid
    join defense_overall d_overall on d_overall.teamid = d_standard.teamid
    join team t on t.teamid = d_overall.teamid
    join conference conf on conf.conferenceid = t.conferenceid
    where conf.division = 'FBS'
),
-- ================= SUFFIX FORMATTER =================
rank_suffixes as (
    select 1 as n union all select 2 union all select 3 union all select 4 union all select 5
)
-- ================= FINAL OUTPUT =================
select 
    'Offense' as Team,
    -- t.teamid,
    -- t.name as Team,
    concat(format(o.std_rate * 100, 1), '% (',
        case 
            when o.std_rank % 100 between 11 and 13 then concat(o.std_rank, 'th')
            when o.std_rank % 10 = 1 then concat(o.std_rank, 'st')
            when o.std_rank % 10 = 2 then concat(o.std_rank, 'nd')
            when o.std_rank % 10 = 3 then concat(o.std_rank, 'rd')
            else concat(o.std_rank, 'th')
        end, ')') as `Standard Down Success %`,
    concat(format(o.pass_rate * 100, 1), '% (',
        case 
            when o.pass_rank % 100 between 11 and 13 then concat(o.pass_rank, 'th')
            when o.pass_rank % 10 = 1 then concat(o.pass_rank, 'st')
            when o.pass_rank % 10 = 2 then concat(o.pass_rank, 'nd')
            when o.pass_rank % 10 = 3 then concat(o.pass_rank, 'rd')
            else concat(o.pass_rank, 'th')
        end, ')') as `Passing Down Success %`,
    concat(format(o.overall_rate * 100, 1), '% (',
        case 
            when o.overall_rank % 100 between 11 and 13 then concat(o.overall_rank, 'th')
            when o.overall_rank % 10 = 1 then concat(o.overall_rank, 'st')
            when o.overall_rank % 10 = 2 then concat(o.overall_rank, 'nd')
            when o.overall_rank % 10 = 3 then concat(o.overall_rank, 'rd')
            else concat(o.overall_rank, 'th')
        end, ')') as `Overall Play Success %`,
    concat(format(o.explosive_rate * 100, 1), '% (',
        case 
            when o.explosive_rank % 100 between 11 and 13 then concat(o.explosive_rank, 'th')
            when o.explosive_rank % 10 = 1 then concat(o.explosive_rank, 'st')
            when o.explosive_rank % 10 = 2 then concat(o.explosive_rank, 'nd')
            when o.explosive_rank % 10 = 3 then concat(o.explosive_rank, 'rd')
            else concat(o.explosive_rank, 'th')
        end, ')') as `Explosive %`
from team t
join offense_ranked o on o.teamid = t.teamid
where t.teamid = :teamid
union all
select 
    'Defense' as Team,
    -- t.teamid,
    -- t.name as Team,
    concat(format(d.std_rate * 100, 1), '% (',
        case 
            when d.std_rank % 100 between 11 and 13 then concat(d.std_rank, 'th')
            when d.std_rank % 10 = 1 then concat(d.std_rank, 'st')
            when d.std_rank % 10 = 2 then concat(d.std_rank, 'nd')
            when d.std_rank % 10 = 3 then concat(d.std_rank, 'rd')
            else concat(d.std_rank, 'th')
        end, ')') as `Standard Down Success %`,
    concat(format(d.pass_rate * 100, 1), '% (',
        case 
            when d.pass_rank % 100 between 11 and 13 then concat(d.pass_rank, 'th')
            when d.pass_rank % 10 = 1 then concat(d.pass_rank, 'st')
            when d.pass_rank % 10 = 2 then concat(d.pass_rank, 'nd')
            when d.pass_rank % 10 = 3 then concat(d.pass_rank, 'rd')
            else concat(d.pass_rank, 'th')
        end, ')') as `Passing Down Success %`,
    concat(format(d.overall_rate * 100, 1), '% (',
        case 
            when d.overall_rank % 100 between 11 and 13 then concat(d.overall_rank, 'th')
            when d.overall_rank % 10 = 1 then concat(d.overall_rank, 'st')
            when d.overall_rank % 10 = 2 then concat(d.overall_rank, 'nd')
            when d.overall_rank % 10 = 3 then concat(d.overall_rank, 'rd')
            else concat(d.overall_rank, 'th')
        end, ')') as `Overall Play Success %`,
    concat(format(d.explosive_rate * 100, 1), '% (',
        case 
            when d.explosive_rank % 100 between 11 and 13 then concat(d.explosive_rank, 'th')
            when d.explosive_rank % 10 = 1 then concat(d.explosive_rank, 'st')
            when d.explosive_rank % 10 = 2 then concat(d.explosive_rank, 'nd')
            when d.explosive_rank % 10 = 3 then concat(d.explosive_rank, 'rd')
            else concat(d.explosive_rank, 'th')
        end, ')') as `Explosive %`
from team t
join defense_ranked d on d.teamid = t.teamid
where t.teamid = :teamid
order by Team desc;
