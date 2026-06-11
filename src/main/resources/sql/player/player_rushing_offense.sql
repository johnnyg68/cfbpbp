-- /CfbPbpSpring/src/main/resources/sql/player/player_rushing_offense.sql

SELECT 
	row_number() over (order by t.yards_g desc) as '#',
    t.name as 'Name',
    t.playerid as 'PlayerId',
    t.team as 'Team',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.atts as Atts,
    t.yards as Yards,
    t.yards_att AS 'Yards/Att',
    t.tds as TDs,
    t.att_g as 'Atts/G',
    t.yards_g as 'Yards/G'
FROM (
SELECT STRAIGHT_JOIN -- force the join order to optimize the query
	player.playername as name,
	player.playerid as playerid,
    team.name as team,
    team.teamid as teamid,
    count(distinct pgs.gameid) as games,
    sum(pgs.rushatts) as atts,
    sum(pgs.rushyards) as yards,
    round(sum(pgs.rushyards) / sum(pgs.rushatts), 2) as yards_att,
    sum(pgs.rushtds) as tds,
    round(sum(pgs.rushatts) / count(distinct pgs.gameid), 2) as att_g,
    round(sum(pgs.rushyards) / count(distinct pgs.gameid), 2) as yards_g
FROM 
	game
	join playergamestat as pgs on pgs.gameid = game.gameid
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join conference on conference.conferenceid = team.conferenceid
WHERE 
	game.year = ? and
	pgs.rushatts > 0 and
	conference.division = 'FBS' 	
GROUP BY
	player.playerid,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
    ) as t
limit 0,100