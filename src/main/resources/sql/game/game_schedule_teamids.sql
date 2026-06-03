-- game/game_schedule_teamids.sql

-- Get Home and Away TeamIds for completed and future games given a GameId
-- This should return only 1 row
select t.awayteamid, t.hometeamid 
from 
(select gameid, awayteamid, hometeamid from schedule 
where complete = 0
union
select gameid, awayteamid, hometeamid from game) as t 
where t.gameid = ?;