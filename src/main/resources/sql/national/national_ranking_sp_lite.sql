-- Team ID, name and mascot from SP+ Rankings for a year

select 
	sp.teamid,
	team.name,
	team.mascot
from sprating as sp
join team on team.teamid = sp.teamid
where 
	sp.year = :year and 
	sp.teamid <> "AVG"
order by sp.teamranking asc;