-- Team Total 3rd Down Conversion
select teamstats.* from
(SELECT 
    row_number() over (order by t.Pct desc) as '#',
	t.TeamId as TeamId,
	t.Games as Games,
	t.Atts as Atts,
	t.Convs as Convs,
	t.Pct as Pct
from (
select
	team.teamid as TeamId,
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
order by
) as t
) as teamstats
where
	teamstats.teamid = :teamid
	
	