-- A team's SOS for a given year relative to all other teams
-- this looks odd, but the subquery is necessary for the SOS Rank to work correctly.

select t.* from (
select
    sos.teamid as TeamId,
    row_number() over (order by (sos.oppw / (sos.oppw + sos.oppl) * 0.66) + (sos.oppoppw / (sos.oppoppw + sos.oppoppl) * 0.33) desc) as "SOS Rank",
    sos.oppw as "Opp W",
    sos.oppl as "Opp L",
    sos.oppw / (sos.oppw + sos.oppl) as "Opp W/L Pct",
    sos.oppoppw as "Opp Opp W",
    sos.oppoppl as "Opp Opp L",
    sos.oppoppw / (sos.oppoppw + sos.oppoppl) as "Opp Opp W/L Pct",
    (sos.oppw / (sos.oppw + sos.oppl) * 0.66) + (sos.oppoppw / (sos.oppoppw + sos.oppoppl) * 0.33) as SOS
from
	team
    join sos on sos.teamid = team.teamid
    join conference as conf on conf.conferenceid = team.conferenceid
where
	conf.division = "FBS" and 
    sos.year = :year) t
where t.teamid = :teamid;