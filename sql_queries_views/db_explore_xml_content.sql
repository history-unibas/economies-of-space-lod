

/*
 * explore available xml automatically encoded texts
 */

select year, pe.annotation_automated, pe.dossierid
from project_entry pe
where pe.annotation_automated is not null
limit 10;

--number : 75353
select count(*)
from project_entry pe
where pe.annotation_automated is not null;

-- example
select pageid, year, pe.annotation_automated, *
from project_entry pe 
--where pe.dossierid = 'HGB_1_002_026' 
where pe.dossierid = 'HGB_1_002_046' 
AND pe.annotation_automated is not null
order by "year" ;



/*
 * Explore XML
 */


select pe.entryid, pe.dossierid, (xpath('//spans', 
pe.annotation_automated, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null;



select pe.entryid, pe.dossierid, unnest(xpath('//eventGroup', 
pe.annotation_automated))
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null;



select pe.entryid, pe.dossierid, (unnest(xpath('//eventGroup/@class', 
pe.annotation_automated)))::text as event_group_class
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
group by pe.entryid, pe.dossierid;



/*
Generic queries

NOT YET ADAPTED TO NEW VERSION

*/

select pe.entryid, pe.dossierid, (xpath('//myns:eventGroup//myns:role[@role ="seller" or @role ="seller" ]/@text', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]
from project_entry pe 
where pe.annotation is not NULL
limit 10;


with tw1 as (
select pe.entryid, pe.dossierid, ((xpath('//myns:eventGroup//myns:role[@role ="seller" or @role ="buyer" ]/@text', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1])::text seller_buyer
from project_entry pe 
where pe.annotation is not NULL
)
select seller_buyer, count(*) as number
from tw1
where seller_buyer ~ 'Falckhner'
group by seller_buyer
order by count(*) desc
limit 500;


with tw1 as (
select pe.entryid, pe.dossierid, pe.year,
((xpath('//myns:eventGroup//myns:role[@role ="seller"]/@text', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1])::text seller,
((xpath('//myns:eventGroup//myns:role[@role ="buyer"]/@text', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1])::text buyer,
((xpath('//myns:eventGroup//myns:role[@role ="property"]/@text', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1])::text property
from project_entry pe 
where pe.annotation is not null

)
select year, seller, buyer, property, entryid, dossierid
from tw1
-- where seller ~ 'Falckhner' or buyer ~ 'Falckhner'
--where seller ~ 'Weibert' or buyer ~ 'Weibert'
limit 100