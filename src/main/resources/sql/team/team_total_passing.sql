-- Passing offense and defense ranked using row_nmber()

-- offense
select
	"Offense" as "Team",
	offense.* 
from
(select 
	tgs.teamid,
	row_number() over (order by round(sum(tgs.passyards) / count(distinct game.gameid) ,2) desc) as "#",
	count(distinct game.gameid) as Games,
	sum(tgs.passatts) as Atts,
	sum(tgs.passcomps) as Comps,
	round(sum(tgs.passcomps) / sum(tgs.passatts) * 100, 2) as Pct,
	sum(tgs.passyards) as Yards,
	round(sum(tgs.passyards) / sum(tgs.passatts), 2) as "Yards/Att",
	sum(tgs.passtds) as TD,
	sum(tgs.passints) as "INT",
	--  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    round(((8.4 * sum(tgs.passyards)) + (330 * sum(tgs.passtds)) - (200 * sum(tgs.passints)) + (100 * sum(tgs.passcomps))) / sum(tgs.passatts), 2) as Rating,
	round(sum(tgs.passatts) / count(distinct game.gameid), 2) as "Att/Game",
	round(sum(tgs.passyards) / count(distinct game.gameid), 2) as "Yards/Game"
from
	teamgamestat as tgs
	join team on team.teamid = tgs.teamid
	join game on game.gameid = tgs.gameid	
	join conference as conf on conf.conferenceid = team.conferenceid
where
	game.year = :year and
    conf.division = "FBS"
group by
	team.teamid) as offense
where
	offense.teamid = :teamid
UNION     
-- defense
select
	"Defense" as "Team",
	defense.* 
from 
(select
	team1.teamid,
	row_number() over (order by round(sum(tgs2.passyards) / count(distinct game.gameid), 2) asc) as "#",    
	count(distinct game.gameid) as Games,
	sum(tgs2.passatts) as Atts,
	sum(tgs2.passcomps) as Comps,
	round((sum(tgs2.passcomps) / sum(tgs2.passatts)) * 100, 2) as Pct,
	sum(tgs2.passyards) as Yards,
	round(sum(tgs2.passyards) / sum(tgs2.passatts), 2) as "Yards/Att",
	sum(tgs2.passtds) as TD,
	sum(tgs2.passints) as "INT",	
	round(((8.4 * sum(tgs2.passyards)) + (330 * sum(tgs2.passtds)) - (200 * sum(tgs2.passints)) + (100 * sum(tgs2.passcomps))) / sum(tgs2.passatts), 2) as Rating,
    round(sum(tgs2.passatts) / count(distinct game.gameid), 2) as "Att/Game",
	round(sum(tgs2.passyards) / count(distinct game.gameid), 2) as "Yards/Game"
from
	teamgamestat as tgs1
	join teamgamestat as tgs2 on tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
	join game as game on game.gameid = tgs1.gameid
	join team as team1 on team1.teamid = tgs1.teamid
	join conference as conf on conf.conferenceid = team1.conferenceid
where
	game.year = :year and
	conf.division = "FBS"
group by 
	team1.teamid) as defense
 where 
	defense.teamid = :teamid
    