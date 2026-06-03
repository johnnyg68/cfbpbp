-- national_ranking_mov.sql 
-- Average MOV for all teams for a year excluding games vs FCS
select 
	row_number() over (order by ((sum(t.homescore) - sum(t.awayscore)) / sum(t.games)) desc) as "#",
	team.name as Team, 
	t.teamid as "TeamId",
    concat(vyearteamrecord.Wins, " - ", vyearteamrecord.Losses) as "Record",
    ap_poll.ranking as "AP Rank",
    spr.teamranking as "SP+ Rank",
    sum(t.games) as Games,
    sum(t.homescore) as "Points Scored",
    sum(t.awayscore) as "Points Allowed",
    (sum(t.homescore) - sum(t.awayscore)) / sum(t.games) as "Avg MOV"
from
(select 
	game.year as "year",
	home.teamid,
    "home" as homeoraway,
    count(*) as games,
    sum(game.homescore) as homescore,
    sum(game.awayscore) as awayscore
from game
join team home on home.teamid = game.hometeamid
join team away on away.teamid = game.awayteamid
join conference homeconf on homeconf.conferenceid = home.conferenceid
join conference awayconf on awayconf.conferenceid = away.conferenceid
where
	game.year = :year and (homeconf.division = "FBS" and awayconf.division = "FBS")
group by
	home.teamid
union
	select 
    game.year as "year",
	away.teamid,
    "away" as homeoraway,
    count(*) as games,
    sum(game.awayscore) as homescore,
    sum(game.homescore) as awayscore
from game
join team home on home.teamid = game.hometeamid
join team away on away.teamid = game.awayteamid
join conference homeconf on homeconf.conferenceid = home.conferenceid
join conference awayconf on awayconf.conferenceid = away.conferenceid
where
	game.year = :year and (homeconf.division = "FBS" and awayconf.division = "FBS")
group by
	away.teamid 
)  t
join team on team.teamid = t.teamid
join sprating spr on spr.teamid = t.teamid and spr.year = :year
join vyearteamrecord on vyearteamrecord.teamid = t.teamid and vyearteamrecord.year = :year
left join ap_poll on team.teamid = ap_poll.teamid and ap_poll.year = :year
group by
	t.teamid;