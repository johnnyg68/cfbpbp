-- SP+ Rankings with record from view vytearteamrecord
select 
	spr.teamranking as 'Rank',
	team.name as 'Team', 
    concat(record.Wins, "-", record.Losses) as Record,
    team.teamid as 'TeamId',
    spr.teamrating as 'Team Rating',
    spr.oranking as 'Off Ranking',
    spr.orating as 'Off Rating',
    spr.dranking as 'Def Ranking',
    spr.drating as 'Def Rating'
from 
	team
	left join sprating as spr on team.teamid = spr.teamid 
	left join vyearteamrecord as record on record.year = spr.year and record.teamid = spr.teamid
where 
	spr.year = :year
order by 
	teamranking asc; 