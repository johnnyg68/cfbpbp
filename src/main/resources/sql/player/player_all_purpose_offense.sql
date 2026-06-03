-- Player All Purpose Offense

-- Name	Team	G	Rush	Recv.	Punt Ret.	Kick Ret.	Plays	Total Yards		Yards/Play		Yards/G

SELECT 
    row_number() over (order by t.yardspergame desc) as '#',
    t.Name as 'Name',
    t.PlayerId as 'PlayerId',
    t.team as 'Team',
    t.teamid as 'TeamId',
    t.games as 'Games',
    t.RushYards as 'Rush Yards',
    t.RecYards as 'Rec Yards',
    t.PuntReturnYards as 'Punt Ret',
    t.KickReturnYards as 'Kick Ret',
    t.Plays as 'Plays',
	t.totalyards as 'Total Yards',
	t.yardsperplay as 'Yards/Play',
	t.yardspergame as 'Yards/G'
from (
select 
	player.playername as Name,
	player.playerid as PlayerId,
    team.name as team,
    team.teamid as teamid,
    count(distinct pgs.gameid) as games,
    sum(pgs.rushyards) as RushYards,
	sum(pgs.passrecyards) as RecYards,
    sum(pgs.puntreturnyards) as PuntReturnYards,
    sum(pgs.kickreturnyards) as KickReturnYards,
    sum(pgs.rushatts) + sum(pgs.passrecs) + sum(pgs.puntreturns) + sum(pgs.kickreturns) as Plays,
    sum(pgs.rushyards) + sum(pgs.passrecyards) + sum(pgs.puntreturnyards) + sum(pgs.kickreturnyards) as totalyards,
    round((sum(pgs.rushyards) + sum(pgs.passrecyards) + sum(pgs.puntreturnyards) + sum(pgs.kickreturnyards)) / (sum(pgs.rushatts) + sum(pgs.passrecs) + sum(pgs.puntreturns) + sum(pgs.kickreturns)), 2) as yardsperplay,
    round((sum(pgs.rushyards) + sum(pgs.passrecyards) + sum(pgs.puntreturnyards) + sum(pgs.kickreturnyards)) / count(distinct pgs.gameid), 2) as yardspergame    
from playergamestat as pgs
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where 
	game.year = ? and conference.division = 'FBS' 
group by 
	player.playerid,
    team.teamid
-- having
--	count(distinct pgs.gameid) >= (count(distinct game.hometeamid) + count(distinct game.awayteamid)) * .75
) as t
limit 0,100
    