-- Bowl game records by conference for a given year.

WITH bowls AS (
    SELECT 
        homeconf.name AS homeconf, 
        awayconf.name AS awayconf,
        -- Assign winner and loser conferences
        CASE 
            WHEN game.winnerteamid = home.teamid THEN homeconf.name
            ELSE awayconf.name 
        END AS WinnerConference,
        CASE 
            WHEN game.winnerteamid != home.teamid THEN homeconf.name
            ELSE awayconf.name 
        END AS LoserConference
    FROM game
    JOIN team AS home ON home.teamid = game.hometeamid 
    JOIN team AS away ON away.teamid = game.awayteamid
    JOIN conference AS homeconf ON homeconf.conferenceid = home.conferenceid
    JOIN conference AS awayconf ON awayconf.conferenceid = away.conferenceid
    WHERE 
        game.bowl IS NOT NULL AND 
        game.year = :year
),
win_count AS (
    SELECT WinnerConference AS Conference, COUNT(*) AS Wins
    FROM bowls
    GROUP BY WinnerConference
),
loss_count AS (
    SELECT LoserConference AS Conference, COUNT(*) AS Losses
    FROM bowls
    GROUP BY LoserConference
)
SELECT 
    w.Conference,
    IFNULL(w.Wins, 0) AS Wins,
    IFNULL(l.Losses, 0) AS Losses
FROM win_count w
LEFT JOIN loss_count l ON w.Conference = l.Conference
UNION
SELECT 
    l.Conference,
    IFNULL(w.Wins, 0) AS Wins,
    IFNULL(l.Losses, 0) AS Losses
FROM loss_count l
LEFT JOIN win_count w ON w.Conference = l.Conference
ORDER BY Conference;