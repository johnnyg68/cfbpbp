-- Top Player passing nationally for a given year

SELECT 
    row_number() over (order by t.yards_g desc) as '#',
    t.Name as 'Name',
    t.PlayerId as 'PlayerId',
    t.Team as 'Team',
    t.TeamId as 'TeamId',
    t.games as 'Games',
    t.Att as Atts,
    t.comp as Comps,
    t.pct as Pct,
    t.yard as Yards,
    t.yards_att AS 'Yards/Att',
    t.td as TDs,
    t.ints as 'Ints',
    t.Rating as Rating,
    t.att_g as 'Atts/G',
    t.yards_g as 'Yards/G'
from (
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as Team,
    team.teamid as TeamId,
    count(distinct pgs.gameid) as games,
    sum(pgs.passatts) as att,
    sum(pgs.passcomps) as comp,
    round(sum(pgs.passcomps) / sum(pgs.passatts) * 100, 2) as pct,
    sum(pgs.passyards) as yard,
    round(sum(pgs.passyards) / sum(pgs.passatts), 2) as yards_att,
    sum(pgs.passtds) as td,
    sum(pgs.passints) as ints,
    --  [ { (8.4 * yards) + (330 * touchdowns) - (200 * interceptions) + (100 * completions) } / attempts ]
    round(((8.4 * sum(pgs.passyards)) + (330 * sum(pgs.passtds)) - (200 * sum(pgs.passints)) + (100 * sum(pgs.passcomps))) / sum(pgs.passatts), 2) as Rating,
    round(sum(pgs.passatts) / count(distinct pgs.gameid), 2) as att_g,
    round(sum(pgs.passyards) / count(distinct pgs.gameid), 2) as yards_g
from 
	playergamestat as pgs
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where 
	game.year = ? and 
	pgs.passatts > 0 and 
	conference.division = 'FBS'
group by 
	-- player.playername, 
	player.playerid,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
    ) as t
limit 0,100
    