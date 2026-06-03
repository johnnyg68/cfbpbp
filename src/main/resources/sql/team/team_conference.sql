-- all FBS teams by conference
select conf.name as Conference, team.name as Team, team.teamid as TeamId
from team 
join conference as conf on conf.conferenceid = team.conferenceid
where conf.division = 'FBS'
group by
	conf.name, team.name, team.teamid
order by
	conf.name, team.name;