-- show a map of all years and weeks. 
-- year, week
-- 2001, 1
-- 2001, 2
-- ...
-- 2001, bowl
-- 2002, 1
-- 2002, 2

-- select distinct game.year as Year, game.week as Week
-- from game
-- order by game.year desc, length(game.week) asc, game.week + 0 asc;

select distinct schedule.year as Year, schedule.week as Week
from schedule
union
select distinct game.year as Year, game.week as Week
from game 
order by year desc, length(week) asc, week + 0 asc;