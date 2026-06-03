SELECT distinct year as Year, name as Name, position as Position, stateprovince as State, ranking as Ranking, stars as Stars, rating as Rating
FROM recruitingplayer as rp
where committedtoteamid = :committedtoteamid
order by year desc, rating desc;