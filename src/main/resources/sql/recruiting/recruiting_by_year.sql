-- Recruiting team rankings for all teamas per year
select 
    rt.ranking as "Recruiting Rank", 
	rt.year as "Year", 
    rt.teamid as TeamId, 
    team.name as Team, 
    IFNULL(ap_poll.ranking, "NR") as "AP Rank",
    (select 
		concat(
			count(CAST(case when game.winnerteamid = team.teamid then 1 end as CHAR)), 
			CAST(' - ' as CHAR), 
			count(CAST(case when game.winnerteamid <> team.teamid then 1 end as CHAR))
        ) 
	from team 
		join game on team.teamid = game.hometeamid or team.teamid = game.awayteamid  
	where 
		team.teamid = rt.teamid and 
		game.year = rt.year
	group by 
		game.year) as 'Record', 
    sum(if(rp.stars = 5, 1, 0)) as "5*", 
    sum(if(rp.stars = 4, 1, 0)) as "4*", 
    sum(if(rp.stars = 3, 1, 0)) as "3*", 
    rt.points as Points
from recruitingteam as rt
join recruitingplayer as rp on (rp.committedtoteamid = rt.teamid and rp.year = rt.year)
join team on team.teamid = rt.teamid
join conference as conf on conf.conferenceid = team.conferenceid
left join ap_poll on ap_poll.teamid = rt.teamid and ap_poll.year = rt.year
where rt.year = :year and
	conf.division = "FBS"
group by rt.ranking, rt.year, rt.teamid, team.name, ap_poll.ranking, rt.points
order by rt.ranking asc