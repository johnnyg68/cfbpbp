-- National Tackles for Loss Allowed
-- includes AP Rank and W-L Record

SELECT 
    @row:=@row + 1 AS '#',
    t.name AS 'Team',
    t.teamid as 'TeamId',
    IFNULL(t.APRANK, "NR") as "AP Rank",
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
    t.games AS 'Games',
    t.qbh as 'QBH',
    t.qbhpergame as'QBH/G',
    t.sacks as Sacks,
    t.sackspergame as 'Sacks/G',
    t.tfl as TFL,
    t.tflpergame as 'TFL/G'
FROM (
select 
	team1.name,
	team1.teamid,
	count(distinct game.gameid) as games,
    ap_poll.ranking as APRANK,    
	sum(tgs2.qbhurries) as qbh,
	round(sum(tgs2.qbhurries) / count(distinct game.gameid), 2) as qbhpergame,
	sum(tgs2.sacks) as sacks,
	round(sum(tgs2.sacks) / count(distinct game.gameid), 2) as sackspergame,
	sum(tgs2.tacklesforloss) as tfl,
	round(sum(tgs2.tacklesforloss) / count(distinct game.gameid), 2) as tflpergame
from teamgamestat AS tgs1 
    JOIN teamgamestat AS tgs2 ON tgs1.gameid = tgs2.gameid
    JOIN game as game on tgs1.gameid = game.gameid
    JOIN team as team1 on team1.teamid = tgs1.teamid
    join conference as conference on conference.conferenceid = team1.conferenceid
    left join ap_poll on ap_poll.teamid = team1.teamid and ap_poll.year = game.year
where
	game.year = :year and
	tgs1.points <> tgs2.points and
	conference.division = 'FBS'
group by
	team1.name,
	team1.teamid,
    ap_poll.ranking
order by
	round(sum(tgs2.tacklesforloss) / count(distinct game.gameid), 2) asc
 ) as t
    CROSS JOIN
    (SELECT @row:=0) AS r
