select
	poll.ranking as "Rank",
    team.name as Team,
    team.teamid as TeamId,
    concat(record.Wins, "-", record.Losses) as Record
from
	team
    left join ap_poll as poll on team.teamid = poll.teamid
    left join vyearteamrecord as record on record.year = poll.year and record.teamid = team.teamid
where
	poll.year = :year
order by
	poll.ranking asc;