select 
    concat("Q", play.period, " ", play.clock) as 'Clock',
	oteam.abbreviation as 'Offense',
    case when play.down = 1 then "1st" 
		when play.down = 2 then "2nd"
        when play.down = 3 then "3rd"
        when play.down = 4 then "4th"
        else "0"
	end as 'Down',
    play.distance as 'Distance',
    if(play.playyardstoendzone < 50, 
		concat(dteam.abbreviation, " ", play.playyardstoendzone),
        concat(oteam.abbreviation, " ", 100 - play.playyardstoendzone)
	) as 'Yard Line',
    play.playtype as 'Type',
    play.playstatyardage as 'Yards',  
    play.playtext as 'Result',
    if(play.scoring, concat(awayteam.abbreviation, " ", play.awayscore, " - ", hometeam.abbreviation, " ", play.homescore), "") as Score
from play
join game on game.gameid = play.gameid
join team as oteam on oteam.teamid = play.offenseteamid
join team as dteam on dteam.teamid = play.defenseteamid
join team as hometeam on game.hometeamid = hometeam.teamid
join team as awayteam on game.awayteamid = awayteam.teamid
where game.gameid= ?
-- order by play.driveid + '0', play.playid + '0' -- this fixes plays sort issue for CFBD sourced plays
order by play.driveid + '0' asc, play.playnumber + '0' asc