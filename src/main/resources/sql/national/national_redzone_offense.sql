SELECT 
    @row:=@row + 1 AS '#',
    t.name AS 'Name',
    t.games AS 'Games',
    t.Atts as Atts,
    t.Scores as Scores,
    t.FGs as 'FGs',
    t.TDs as TDs,
    t.ScorePct as 'Score %'
FROM (
SELECT 
    team.name as Name,
    COUNT(DISTINCT game.gameid) as Games,
    SUM(drive.redzoneattempt) as Atts,
    SUM(drive.redzonefg) + SUM(drive.redzonetd) as Scores,
    SUM(drive.redzonefg) as FGs,
    SUM(drive.redzonetd) as TDs,
    ROUND((SUM(drive.redzonetd) + SUM(redzonefg)) / SUM(drive.redzoneattempt) * 100, 2) as ScorePct
FROM
    drive
        JOIN game ON game.gameid = drive.gameid
        JOIN team ON team.teamid = drive.offenseiveteamid
        JOIN conference ON conference.conferenceid = team.conferenceid
WHERE
    game.year = :year and 
    conference.division = 'FBS'
GROUP BY team.teamid
ORDER BY ROUND((SUM(drive.redzonetd) + SUM(drive.redzonefg)) / SUM(drive.redzoneattempt) * 100, 2) DESC
) as t
    CROSS JOIN
    (SELECT @row:=0) AS r