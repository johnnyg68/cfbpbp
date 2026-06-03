-- Team Total 3rd Down Conversion offense and defense
select
	"Offense" as "Team",
	teamoffense.* 
from (
select
	team.teamid as TeamId,
	row_number() over (order by sum(tgs.thirddownconvs) / round(sum(tgs.thirddownatts), 2) desc) as "#",
	count(distinct game.gameid) as Games,
	sum(tgs.thirddownatts) as Atts,
	sum(tgs.thirddownconvs) as Convs,
	round(sum(tgs.thirddownconvs) / sum(tgs.thirddownatts) * 100, 2) as Pct
from teamgamestat as tgs
	join team as team on team.teamid = tgs.teamid 
	join game as game on game.gameid = tgs.gameid
	join conference on conference.conferenceid = team.conferenceid
where
	game.year = :year and
	conference.division = 'FBS'
group by
	team.teamid
) as teamoffense
where
	teamoffense.teamid = :teamid
UNION
select 
	"Defense" as "Team",
	teamdefense.* 
from (
select
	team1.teamid,
	row_number() over (order by round(sum(tgs2.thirddownconvs) / sum(tgs2.thirddownatts) * 100, 2) asc) as "#",
	count(distinct tgs2.gameid) as Games,
	sum(tgs2.thirddownatts) as Atts,
	sum(tgs2.thirddownconvs) as Convs,
	round(sum(tgs2.thirddownconvs) / sum(tgs2.thirddownatts) * 100, 2) as Pct
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
) as teamdefense
where teamdefense.teamid = :teamid
	
	