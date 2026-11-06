-- SP+ Rankings with record from view vytearteamrecord
select 
	spr.teamranking as 'Team Ranking',
    spr.teamrating as 'Team Rating',
    spr.oranking as 'Off Ranking',
    spr.orating as 'Off Rating',
    spr.dranking as 'Def Ranking',
    spr.drating as 'Def Rating'
from 
	sprating as spr 
where 
	spr.year = :year and
	spr.teamid = :teamid;