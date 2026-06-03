-- Drives and Plays
select * from 
(SELECT 
	play.driveid + '0' as driveid,
	play.playid  as playid,
    concat('Q', play.period,' ', play.clock) as 'Clock',
	oteam.abbreviation as 'Offense',
    case when play.down = 1 then '1st'
		when play.down = 2 then '2nd'
        when play.down = 3 then '3rd'
        when play.down = 4 then '4th'
        else '0'
	end as 'Down',
    play.distance as 'Distance',
    if(play.playyardstoendzone < 50, 
		concat(dteam.abbreviation, " ", play.playyardstoendzone),
        concat(oteam.abbreviation, " ", 100 - play.playyardstoendzone)
	) as 'Yard Line',
    play.playtype as 'Type',
    play.playstatyardage as 'Yards',  
    play.playtext as 'Result',
    if(play.scoring, concat(awayteam.abbreviation, ' ', play.awayscore, ' - ', hometeam.abbreviation, ' ', play.homescore), '') as Score
from play
join game on game.gameid = play.gameid
join team as oteam on oteam.teamid = play.offenseteamid
join team as dteam on dteam.teamid = play.defenseteamid
join team as hometeam on game.hometeamid = hometeam.teamid
join team as awayteam on game.awayteamid = awayteam.teamid
where game.gameid = :gameid) as plays
join
	(select distinct 
		drive.driveid, 
		team.name as Team, 
		concat('Q',drive.startperiod) quarter, 
		drive.startclock, drive.totalplays, 
		drive.totalyards,  
		RIGHT(SEC_TO_TIME(drive.timeelapsed), 5) duration, 
		drive.result as DriveResult
	from drive
	join team on team.teamid = drive.offenseteamid
	where drive.gameid = :gameid
	) as drives on drives.driveid = plays.driveid
order by abs(plays.driveid + '0') asc, plays.playid asc;