-- Team sacks and tackles for loss
-- includes AP Rank and W-L record

SELECT 
    @row:=@row + 1 AS '#',
    t.name AS 'Team',
    t.teamid AS 'TeamId',
	IFNULL(t.ranking, "NR") as "AP Rank",
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
    t.qbhpergame as 'QBH/G',
    t.sacks as Sacks,
    t.sackspergame as 'Sacks/G',
    t.tfl as TFL,
    t.tflpergame as 'TFL/G'
FROM (
select 
	team.name,
	team.teamid,
    ap_poll.ranking,
	count(distinct tgs.gameid) as games,
	sum(tgs.qbhurries) as qbh,
	round(sum(tgs.qbhurries) / count(distinct tgs.gameid), 2) as qbhpergame,
	sum(tgs.sacks) as sacks,
	round(sum(tgs.sacks) / count(distinct tgs.gameid), 2) as sackspergame,
	sum(tgs.tacklesforloss) as tfl,
	round(sum(tgs.tacklesforloss) / count(distinct tgs.gameid), 2) as tflpergame
from
	teamgamestat as tgs
	join team on team.teamid = tgs.teamid
	join game on game.gameid = tgs.gameid
	join conference on conference.conferenceid = team.conferenceid
    left join ap_poll on ap_poll.teamid = team.teamid and ap_poll.year = game.year
where
	game.year = :year and
	conference.division = 'FBS'
group by
	team.name, team.teamid, ap_poll.ranking
order by
	round(sum(tgs.tacklesforloss) / count(distinct tgs.gameid), 2) desc
 ) as t
    CROSS JOIN
    (SELECT @row:=0) AS r
