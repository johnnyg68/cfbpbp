-- Team Total 3rd Down Defense
select teamstats.* from
(SELECT 
    row_number() over (order by t.pct asc) as '#',
    t.teamid AS 'TeamId',
    t.games AS 'Games',
    t.atts AS 'Atts',
    t.convs AS 'Convs',
    t.pct AS 'Pct'
from (
select
	team1.teamid,
	count(distinct tgs2.gameid) as games,
	sum(tgs2.thirddownatts) as atts,
	sum(tgs2.thirddownconvs) as convs,
	round(sum(tgs2.thirddownconvs) / sum(tgs2.thirddownatts) * 100, 2) as pct
from
	teamgamestat as tgs1
	join teamgamestat as tgs2 on tgs1.gameid = tgs2.gameid and tgs1.teamid <> tgs2.teamid
	join game as game on game.gameid = tgs1.gameid
	join team as team1 on team1.teamid = tgs1.teamid
	join conference as conf on conf.conferenceid = team1.conferenceid
where
	game.year = :year and
	conf.division = 'FBS' 
group by 
	team1.teamid
	) as t
) as teamstats
where teamstats.teamid = :teamid