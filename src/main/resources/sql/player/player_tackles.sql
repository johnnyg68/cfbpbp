SELECT 
    row_number() over (order by t.tackles_game desc) as '#',
	t.playername as Name,
	t.playerid as PlayerId,
	t.name as Team,
	t.teamid as TeamId,
	t.games as Games,
	t.tackles as Tackles,
	t.solo as Solo,
	t.tfl as TFL,
	t.sacks as Sacks,
	t.tackles_game as "Tackles/G"
from(
select 
	player.playername,
	player.playerid,
	team.name,
	team.teamid,
	count(distinct pgs.gameid) as games,
	sum(pgs.tackles) as tackles,
	sum(pgs.tacklessolo) as solo,
	sum(pgs.tacklesforloss) as tfl,
	sum(pgs.sacks) as sacks,
	round(sum(pgs.tackles) / count(distinct pgs.gameid), 2) as tackles_game
from
	playergamestat as pgs
	join player on player.playerid = pgs.playerid and player.teamid = pgs.teamid
    join team on team.teamid = pgs.teamid
	join game on game.gameid = pgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where
	(pgs.tacklesforloss > 0 or pgs.tackles > 0 or pgs.sacks > 0) and
	conference.division = 'FBS' and
	game.year = ?
group by
	player.playername,
	player.playerid,
	team.name,
	team.teamid
   ) as t
limit 0,100