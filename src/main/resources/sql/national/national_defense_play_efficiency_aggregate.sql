-- national/national_defense_play_efficiency_aggregate.sql
-- use teamdownsuccesstable which aggregates play<type>, and success 
select 
	team.name as Team,
	tds.teamid as TeamId,
	concat(stdsuccessfulplays, "/",  stdplays) as "Success/Std Downs",
	stdsuccessrate as "Std Success %",
	tds.stdrank as "Std Success Rank",
	concat(passingsuccessfulplays, "/", passingplays ) as "Success/Pass Downs",
	tds.passingsuccessrate as "Pass Success %",
	tds.passingrank as "Pass Success Rank",
	concat(allsuccessfulplays, "/", allplays  ) as "Success/All Downs",
	allsuccessrate as "All Success %",
	allrank as "All Success Rank"
from 
	teamdownsuccess tds
	join team on team.teamid = tds.teamid 
	join conference on conference.conferenceid  = team.conferenceid 
where 
	year = :year and 
	side = 'Defense' and
	conference.division = 'fbs'
order by allrank asc;