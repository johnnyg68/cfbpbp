-- Team ID, name and mascot from SP+ Rankings for a year

select
	sp.year,
	sp.teamid,
	team.name,
	team.mascot
from sprating as sp
join team on team.teamid = sp.teamid
where 
	sp.year = (select max(year) from sprating) and 
	sp.teamid <> "AVG"
order by sp.teamranking asc;