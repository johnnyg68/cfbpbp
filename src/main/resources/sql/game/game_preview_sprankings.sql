select
	team.name as Team,
	sp.teamranking as "Team Ranking",
	sp.teamrating as "Team Rating", 
	sp.oranking as "Off Ranking",
	sp.orating as "Off Rating",
	sp.dranking as "Def Ranking",
	sp.drating as "Def Rating"
from schedule 
join team on team.teamid = schedule.hometeamid 
join sprating as sp on sp.teamid = schedule.hometeamid
where schedule.hometeamid = :hometeamid and sp.year = :year
union
select
	team.name as Team,
	sp.teamranking as "Team Ranking",
	sp.teamrating as "Team Rating", 
	sp.oranking as "Off Ranking",
	sp.orating as "Off Rating",
	sp.dranking as "Def Ranking",
	sp.drating as "Def Rating"
from schedule 
join team on team.teamid = schedule.awayteamid 
join sprating as sp on sp.teamid = team.teamid
where schedule.awayteamid = :awayteamid and sp.year = :year