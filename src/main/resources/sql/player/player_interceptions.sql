-- Player Interceptions for year
select 
    row_number() over (order by t.int_games desc) as '#',
	t.playername as "Name",
	t.playerid as PlayerId,
	t.name as Team,
	t.teamid as TeamId,
	t.games as Games,
	t.INT as "INT",
	t.Yards as Yards,
	t.TD as TD,
    t.int_games as "INT/Games"
from (
select 
	player.playername,
	player.playerid,
	team.name,
	team.teamid,
	count(distinct pgs.gameid) as Games,
    sum(pgs.defints) as "INT",
    sum(pgs.defintyards) as "Yards",
    sum(pgs.deftds) as "TD",   
    round(sum(pgs.defints) / count(distinct pgs.gameid), 2) as "int_games"
from
	playergamestat as pgs
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where
	(pgs.tacklesforloss > 0 or pgs.tackles > 0 or pgs.sacks > 0 or pgs.defints > 0) and
	conference.division = 'FBS' and
	game.year = ?
group by
	player.playerid,
	team.teamid
    ) as t
limit 0,100