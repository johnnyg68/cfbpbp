--  Offense Drive scoring % for all teams for a year
select 
	row_number() over (order by t.pointsPerDrive desc) as '#',
	t.name as 'Team',
    t.teamid as 'TeamId',
    t.Drives as 'Drives',
    t.AvgStartSpot as 'Start Yards to End Zone',
    t.plays as 'Plays',
    t.time as 'Time',
    t.yards as 'Yards',
    t.Scoring as 'Scoring Drives',
    t.pct as '% Scored',
    t.pointsScored as 'Points',
    t.pointsPerDrive as 'Points/Drive'
from
(select 
	team.name,
    team.teamid,
    count(*) as Drives,
    round(avg(drive.startyardstoendzone), 2) as AvgStartSpot,
    round(avg(drive.totalplays), 2) as plays,
    RIGHT(SEC_TO_TIME(round(avg(drive.timeelapsed))), 5) as time,
    round(avg(drive.totalyards), 2) as yards,
    sum(drive.scoring) as 'Scoring',
    avg(drive.scoring) as 'pct',
    sum(drive.pointsscored) as 'pointsScored',
    sum(drive.pointsscored) / count(*) as 'pointsPerDrive'
from drive
	join game on game.gameid = drive.gameid
    join team on team.teamid = drive.offenseteamid
    join conference as conf on conf.conferenceid = team.conferenceid
where
	game.year = :year and
    conf.division = 'FBS'
group by
	team.teamid
) as t
