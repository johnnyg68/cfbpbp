select week
from schedule
where year = :year and complete = 0
order by length(week) asc, week + 0 asc
limit 1;