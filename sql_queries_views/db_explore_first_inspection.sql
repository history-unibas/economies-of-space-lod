/*
 * This documents provides queries analysing 
 * basic features of the database
 */

-- documents where the annotated text is available
select count(*) as number
from project_entry pe 
where pe.annotation_automated is not null
;

-- documents without text
select count(*) as number
from project_entry pe 
where pe.annotation_automated is null
;


-- inspect structure of table as is
select *
from project_entry pe 
where pe.annotation_automated is not null
order by dossierid, pageid 
limit 30;

-- associate metadata (address, etc.)
select sd.dossierid, sd.serieid, sd.stabsid, sd.title, 
	sd.housename, sd.oldhousenumber , sd.owner1862, sd.descriptivenote ,
	pe."year" , pe."source" , pe."language", pe.pageid,
	pd."location" , pd.locationorigin, pd.locationaccuracy 
from project_entry pe, stabs_dossier sd , project_dossier pd 
where pe.annotation_automated is not null
and sd.dossierid = pe.dossierid 
and pd.dossierid = sd.dossierid 
order by sd.dossierid
limit 30;


-- url image, xml
select sd.dossierid, sd.serieid, sd.stabsid, tp.urlimage, sd.title  stbs_title, 
	sd.housename, sd.oldhousenumber , sd.owner1862, 
	pe.annotation_automated, sd.descriptivenote ,
	pe."year" , pe."source" , pe."language", pe.entryid, pe.pageid,
	pd."location" , pd.locationorigin, pd.locationaccuracy 
from project_entry pe, project_dossier pd , stabs_dossier sd, transkribus_page tp 
where pe.annotation_automated is not null 
and pd.dossierid = sd.dossierid 
and sd.dossierid = pe.dossierid 
and tp.entryid = pe.entryid 
and sd.dossierid = 'HGB_1_001_027'
order by sd.dossierid
limit 30;

/* 
 * interesting example
 * HGB_1_001_027	HGB_1_001	HGB 1 1/27	https://files.transkribus.eu/Get?fileType=view&id=JNKJRJPSKBCTRXPLJGJGWNNK	Aeschengraben 20		Theil von 972		[XML]	mit Einschluss von Hirschgasse 17 seit [...]. Bis 1516, nachher siehe 20/24.	1424	Gerichtsarchiv	german	{47426337}	POINT (2611634.7500621113 1266658.8446067385)	manuell gesetzt	ungefähr gesetzt
 * 
 */

/*
 * Distribution dans les temps
 * 
 */

-- min, max years
select min(pe."year" ), max(pe."year" )
from project_entry pe 
where pe.annotation_automated is not null;


WITH RECURSIVE periods AS (
    SELECT 1300 AS year_b, 1351 as year_e
    UNION ALL
    SELECT year_b + 50, year_e + 50
    FROM periods
    WHERE year_b < 1750
)
SELECT * FROM periods;


-- Distribution of documents by periods
WITH RECURSIVE periods AS (
    SELECT 1300 AS year_b, 1351 as year_e
    UNION ALL
    SELECT year_b + 50, year_e + 50
    FROM periods
    WHERE year_b < 1750
), years_with_periods AS(
select pe."year", CONCAT(ps.year_b, '_', ps.year_e ) as period
from project_entry pe, periods ps
where pe.annotation_automated is not null
and pe."year" > ps.year_b and pe."year" < ps.year_e)
select period, count(*) as number
from years_with_periods 
group by "period" 
order by period;



create view v_dossier_id_page_id AS
select pe.dossierid, unnest(pe.pageid) as pageid 
from project_entry pe ;

select *
from v_dossier_id_page_id
limit 10;
