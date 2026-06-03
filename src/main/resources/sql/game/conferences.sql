-- in src/main/resources
-- get all conferences in FBS
select name as name from conference where conference.division = 'FBS' order by name asc;