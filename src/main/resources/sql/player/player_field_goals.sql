-- Player FG Kicking

-- #	Name	Team	G	Att.	Made	Pct.	Att/G	Made/G

SELECT 
    row_number() over (order by t.madepergame desc) as '#',
    t.name as 'Name',
    t.team as 'Team',
    t.games as 'Games',
    t.atts as Atts,
    t.made as Made,
    t.pct AS Pct,
    t.attspergame as 'Atts/G',
	t.madepergame as 'Made/G'
from (
select 
	player.playername as Name,
    team.name as team,
    count(distinct pgs.gameid) as games,
    sum(pgs.fieldgoalatts) as atts,
    sum(pgs.fieldgoalsmade) as made,
    round(sum(pgs.fieldgoalsmade) / sum(pgs.fieldgoalatts) * 100, 2) as pct,
    round(sum(pgs.fieldgoalatts) / count(distinct pgs.gameid), 2) as attspergame,
	round(sum(pgs.fieldgoalsmade) / count(distinct pgs.gameid), 2) as madepergame
from playergamestat as pgs
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where 
	game.year = ? and 
	conference.division = 'FBS' 	
group by 
	player.playerid,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
    ) as t
limit 0,100