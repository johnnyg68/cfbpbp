-- preview game header 
select 
	schedule.gameid,
	concat(awayteam.name, " at ", hometeam.name, " ", date_format(schedule.date, "%m-%d-%Y")) as Title,
	date_format(schedule.date, "%m-%d-%Y") as Date,
	schedule.year as Year,
	schedule.week as Week,
	schedule.site as Site,
	hometeam.teamid as 'HomeTeamId',
	hometeam.name as 'HomeTeamName',
	hometeam.mascot as 'HomeTeamMascot',
	hometeam.abbreviation as 'HomeTeamAbbreviation',
	homerank.ranking as 'HomeTeamRank',
	concat(homerecord.Wins," - ", homerecord.Losses) as "HomeTeamRecord",
	awayteam.teamid as 'VisitorTeamId',
	awayteam.name as 'VisitorTeamName',
	awayteam.mascot as 'VisitorTeamMascot',
	awayteam.abbreviation as 'VisitorTeamAbbreviation',
	awayrank.ranking as 'VisitorTeamRank',
	concat(awayrecord.Wins," - ", awayrecord.Losses) as "VisitorTeamRecord"
from
	schedule 
    left join team as hometeam on hometeam.teamid = schedule.hometeamid
    left join team as awayteam on awayteam.teamid = schedule.awayteamid
    left join vyearteamrecord as homerecord on homerecord.TeamId = schedule.hometeamid and homerecord.year = :year
    left join vyearteamrecord as awayrecord on awayrecord.TeamId = schedule.awayteamid and awayrecord.year = :year
    left join ap_poll as homerank on homerank.teamid = schedule.hometeamid and homerank.year = :year 
    left join ap_poll as awayrank on awayrank.teamid = schedule.awayteamid and awayrank.year = :year
where
	schedule.gameid = :gameid
-- group by 
-- 	schedule.gameid;