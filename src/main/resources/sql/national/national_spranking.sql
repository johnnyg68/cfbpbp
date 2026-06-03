select 
	sprating.teamranking as 'Rank',
	team.name as 'Team', 
    team.teamid as 'TeamId',
    sprating.teamrating as 'Team Rating',
    sprating.oranking as 'Off Ranking',
    sprating.orating as 'Off Rating',
    sprating.dranking as 'Def Ranking',
    sprating.drating as 'Def Rating'
from cfb_pbp.sprating
join team on team.teamid = sprating.teamid
where sprating.year = :year
order by teamranking asc; 