-- THIS WORKS
-- GET THE AP RANK and WIN/LOSS RECORDS FOR ALL FBS TEAMS FOR ALL YEARS
-- I made this a view. See view: vteamyearrecord
select t1.year, t1.teamid, t1.name, ifnull(t1.rank, "NR") as "AP Rank", t1.record from
(select 
	game.year,
    game.date,
    team.teamid,
    team.name,
    ap_poll.ranking as "AP Rank",
    if(team.teamid = game.hometeamid, game.homerecord, game.awayrecord) as record
from game
join team on (team.teamid = game.hometeamid or team.teamid = game.awayteamid)
join conference conf on conf.conferenceid = team.conferenceid
left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
where conf.division = "FBS") t1
INNER JOIN 
(select 
	team.teamid, max(game.date) as maxdate
from game
join team on (team.teamid = game.hometeamid or team.teamid = game.awayteamid)
join conference conf on conf.conferenceid = team.conferenceid
where conf.division = "FBS"
group by team.teamid, game.year
) t2
on t1.teamid = t2.teamid and t1.date = t2.maxdate