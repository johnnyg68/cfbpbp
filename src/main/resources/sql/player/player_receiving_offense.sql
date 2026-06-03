-- Top Player Receiving Offense nationally for a given year.

--	Name	Team	G	Rec.	Yards	Avg.	TD	Rec./G	Yards/G
SELECT 
	row_number() over (order by t.yards_g desc) as '#',
    t.name as 'Name',
    t.playerId as 'PlayerId',
    t.team as 'Team',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.recs as Recs,
    t.yards as Yards,
    t.yards_att AS 'Avg',
    t.tds as TDs,
    t.recs_g as 'Recs/G',
    t.yards_g as 'Yards/G'
from (
select 
	player.playername as Name,
	player.playerid as playerid,
    team.name as team,
    team.teamid as teamid,
    count(distinct pgs.gameid) as games,
    sum(pgs.passrecs) as recs,
    sum(pgs.passrecyards) as yards,
    round(sum(pgs.passrecyards) / sum(pgs.passrecs), 2) as yards_att,
    sum(pgs.passrectds) as tds,
    round(sum(pgs.passrecs) / count(distinct pgs.gameid), 2) as recs_g,
    round(sum(pgs.passrecyards) / count(distinct pgs.gameid), 2) as yards_g
from 
	playergamestat as pgs
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where 
	game.year = ? and 
	pgs.passrecs > 0 and
	conference.division = 'FBS' 	
group by 
	player.playerid,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
    ) as t
limit 0,100