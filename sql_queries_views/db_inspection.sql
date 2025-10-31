

select count(*) as number
from project_entry pe 
where pe.annotation is not null
;

select count(*) as number
from project_entry pe 
where pe.annotation is null
;


-- inspect structure of table
select *
from project_entry pe 
where pe.annotation is not null
order by dossierid, pageid 
limit 30;


select sd.dossierid, sd.serieid, sd.stabsid, sd.title, sd.housename, sd.oldhousenumber , sd.owner1862, sd.descriptivenote ,
pe."year" , pe."source" , pe."language", pe.pageid,
pd."location" , pd.locationorigin, pd.locationaccuracy 
from project_entry pe, stabs_dossier sd , project_dossier pd 
where pe.annotation is not null
and sd.dossierid = pe.dossierid 
and pd.dossierid = sd.dossierid 
order by sd.dossierid
limit 30;

