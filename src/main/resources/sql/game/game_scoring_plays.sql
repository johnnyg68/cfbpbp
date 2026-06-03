select 
	team.name as "Team",
    concat("Q", play.period, " ", play.clock) as "Clock",
    play.playtext as "Scoring Play",
	play.awayscore as Visitor,
	play.homescore as Home
from
	play
	join team on team.teamid = play.scoringteamid
    join game on game.gameid = play.gameid
where
	game.gameid = ? and
	play.scoring = 1
order by
	play.period,
	play.playid + 0