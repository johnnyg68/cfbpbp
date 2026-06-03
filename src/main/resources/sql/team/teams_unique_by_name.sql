-- sql in resources
select distinct team.teamid as TeamId, team.name as Name
from team
join conference as conf on conf.conferenceid = team.conferenceid
where conf.division = "FBS"
order by team.name;