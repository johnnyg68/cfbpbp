-- Aggregate of Win-Loss-Te for all teams across all years
-- Requires manual updates. See: com.jmg.cfb_pbp.data.updatesV2.InsertGamesHistory
SELECT 
	team.TeamId, 
	team.Name, 
	SUM(Win) As Wins, 
	SUM(Loss) as Losses, 
	SUM(Tie) as Ties, 
	SUM(Win) + SUM(Loss) + SUM(Tie) as Games,
	Avg(Win) as Pct 
FROM
( SELECT 
	 hometeamid as TeamId, 
     CASE WHEN homescore > awayscore THEN 1 ELSE 0 END as Win, 
     CASE WHEN homescore < awayscore THEN 1 ELSE 0 END as Loss,
     CASE WHEN homescore = awayscore THEN 1 ELSE 0 END as Tie
  FROM gamehistory as gh
  UNION ALL
  SELECT 
  	 awayteamid as TeamId,
     CASE WHEN awayscore > homescore THEN 1 ELSE 0 END as Win, 
     CASE WHEN awayscore < homescore THEN 1 ELSE 0 END as Loss,
     CASE WHEN awayscore = homescore THEN 1 ELSE 0 END as Tie
  FROM gamehistory as gh
) t
join team on team.teamid = t.teamid
GROUP BY team.TeamId
ORDER By Wins desc, Losses desc;