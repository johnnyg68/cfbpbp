-- Player Total offense

-- 	Name	Team	G	Rush Yards	Pass Yards	Plays	Total Yards	Yards/Play	Yards/G

SELECT 
    row_number() over (order by t.YardsPerGame desc) as '#',
    t.Name as 'Name',
    t.playerid as 'PlayerId',
    t.team as 'Team',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.RushYards as 'Rush Yards',
    t.PassYards as 'Pass Yards',
    t.Plays as 'Plays',
    t.TotalYards as 'Total Yards',
    t.YardsPerPlay as 'Yards/Play',
	t.YardsPerGame as 'Yards/G'
from (
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as team,
    team.teamid as teamid,
    count(distinct pgs.gameid) as games,
    sum(pgs.rushyards) as RushYards,
    sum(pgs.passyards) as PassYards,
    sum(pgs.rushatts) + sum(pgs.passatts) + sum(pgs.passrecs) + sum(pgs.kickreturns) + sum(pgs.puntreturns) as Plays,
    sum(pgs.rushyards) + sum(pgs.passyards) + sum(pgs.passrecyards) + sum(pgs.kickreturnyards) + sum(pgs.puntreturnyards) as TotalYards,
    round((sum(pgs.rushyards) + sum(pgs.passyards) + sum(pgs.passrecyards) + sum(pgs.kickreturnyards) + sum(pgs.puntreturnyards)) / (sum(pgs.rushatts) + sum(pgs.passatts) + sum(pgs.passrecs) + sum(pgs.kickreturns) + sum(pgs.puntreturns)), 2) as YardsPerPlay,
	round((sum(pgs.rushyards) + sum(pgs.passyards) + sum(pgs.passrecyards) + sum(pgs.kickreturnyards) + sum(pgs.puntreturnyards)) / count(distinct pgs.gameid), 2) as YardsPerGame
from playergamestat as pgs
join team on team.teamid = pgs.teamid
join game on game.gameid = pgs.gameid
join conference on conference.conferenceid = team.conferenceid
join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
where 
	game.year = ? and pgs.passatts > 0 and conference.division = 'FBS'
group by 
	player.playerid,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
) as t

limit 0,200
    