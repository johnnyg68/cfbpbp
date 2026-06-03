select year, round(max(week + 0), 0) as maxweek 
from polls 
group by year
order by year desc;