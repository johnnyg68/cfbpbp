-- national_scoring_offense.sql
-- includes AP Rank and W/L Record
-- includes Points/Play

SELECT 
    @row:=@row + 1 AS '#',
    t.NAME as Team,
    t.TEAMID as TeamId,
    IFNULL(t.APRANK, "NR") as 'AP Rank',
    (select 
		concat(
			count(CAST(case when game.winnerteamid = team.teamid then 1 end as CHAR)), 
			CAST(' - ' as CHAR), 
			count(CAST(case when game.winnerteamid <> team.teamid then 1 end as CHAR))
        ) 
	from team 
		join game on team.teamid = game.hometeamid or team.teamid = game.awayteamid  
	where 
		team.teamid = t.teamid and 
		game.year = :year
	group by 
		game.year) as 'Record',
    t.GAMES as Games,
    t.TD as TD,
    t.FG as FG,
    t.XP1 as 1XP,
    t.POINTS as Points,
    t.POINTS_PLAY as 'Points/Play',
	t.POINTS_GAME as 'Points/G'
from (
	select team.name as NAME,
	team.teamid as TEAMID,
    ap_poll.ranking as APRANK,
	count(distinct game.gameid) as GAMES,
	sum(tgs.rushtds) + sum(tgs.passtds) + sum(tgs.kickreturntds) + sum(tgs.puntreturntds) + sum(tgs.deftds) as TD,
	sum(tgs.fieldgoalsmade) as FG,
	sum(tgs.xpsmade) as 'XP1',
	sum(tgs.points) as POINTS,
    sum(tgs.points) / (sum(tgs.rushatts) + sum(tgs.passatts))  as POINTS_PLAY,
	round(sum(tgs.points) / count(distinct game.gameid), 2) as POINTS_GAME
from 
	teamgamestat as tgs
	join game as game on game.gameid = tgs.gameid
	join team as team on team.teamid = tgs.teamid
	join conference on conference.conferenceid = team.conferenceid
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
where 
	game.year = :year and
	conference.division = 'FBS'
group by
	team.name,
	team.teamid,
    ap_poll.ranking
order by
	sum(tgs.points) / count(distinct game.gameid) desc) as t
CROSS JOIN
    (SELECT @row:=0) AS r;