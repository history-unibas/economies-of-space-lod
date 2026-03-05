/*
 * FB, 3 March 2026
 * Rewritten the whole scripts and produced the tables
 * using the new data and structure
 * 
 */

select *
from project_entry pe
where pe.annotation_automated is not null
limit 10;




-- first level reference span
select unnest(xpath('//spans/span', 
pe.annotation_automated)) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
order by year;


-- all levels spans
select unnest(xpath('//span', 
pe.annotation_automated)) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
order by dossierid, year, entryid;


-- add the span id
with tw1 as (
select unnest(xpath('//span', 
pe.annotation_automated)) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
)
select dossierid, entryid, year, span, 
	(xpath('/span/@id', 
	span))[1]::text::integer as span_id
from tw1
order by dossierid, year, entryid, span_id;	


-- extract all relevant attributes from all levels spans
with tw1 as (
select unnest(xpath('//span', 
pe.annotation_automated)) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
)
select year, 
	(xpath('/span/@text', 
	span))[1]::text as span_text,
	(xpath('/span/@class', 
	span))[1]::text as span_class,
	(xpath('/span/@element', 
	span))[1]::text as span_element,
	(xpath('/span/@id', 
	span))[1]::text::integer as span_id,
	xpath('/span/span/@id', 
	span) as children,
	span, null as parent_span_id, dossierid, entryid
from tw1;


-- errors in encoding corrected with regex
with tw1 as (select unnest(xpath('//span/@id', 
pe.annotation_automated))::text as span_id,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.annotation_automated is not null)
select *
from tw1 
where span_id ~ '_';



-- create table with all the spans
drop table t_spans	;
create table t_spans as
with tw1 as (
select unnest(xpath('//span', 
pe.annotation_automated)) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.annotation_automated is not null
)
select year, 
	(xpath('/span/@text', 
	span))[1]::text as span_text,
	(xpath('/span/@class', 
	span))[1]::text as span_class,
	(xpath('/span/@element', 
	span))[1]::text as span_element,
	-- cast to integer only possible after extracting digits
	substring((xpath('/span/@id', 
	span))[1]::text FROM '^(\d+)')::integer  as span_id,
	xpath('/span/span/@id', 
	span) as children,
	span, 0 as parent_span_id, dossierid, entryid
from tw1
order by dossierid, year, entryid;


select count(*) as number
from t_spans;

select *
from t_spans ts 
--order by dossierid, year, span_id 
offset 200
limit 50;


select *
from t_spans ts 
order by dossierid, year, span_id 
offset 200
limit 50;

-- empty column !!!
update t_spans ts
set parent_span_id = null;


-- children with parents
select span, unnest(children)::text::integer as child_id, span_id as parent_id, ts.dossierid, ts.entryid 
from t_spans ts 
where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
order by parent_id, child_id
limit 20;




-- add parents to child spans
with tw1 as (select substring(unnest(children)::text FROM '^(\d+)')::integer as child_id, span_id as parent_id, ts.dossierid, ts.entryid
from t_spans ts)
update t_spans ts
set parent_span_id = tw1.parent_id
from tw1
where ts.span_id = tw1.child_id 
and ts.dossierid = tw1.dossierid 
and  ts.entryid = tw1.entryid;


select *
from t_spans ts 
where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
--order by parent_id, child_id
limit 200;


/*
 * Explore
 */

select count(*)
from t_spans ts ;


select ts.span_class, count(*) number
from t_spans ts 
group by span_class 
order by number desc;


select *
from t_spans ts 
where ts.span_class = 'buyer'
order by span_text ;


select ga.adresse, ga.eigent1862, ga.hausname, ts.*
from t_spans ts 
	join project_dossier pd on pd.dossierid = ts.dossierid 
	join stabs_dossier sd on sd.dossierid = pd.dossierid 
	join geo_address ga on ga.signatur = sd.stabsid 
where ts.span_class = 'buyer'
order by span_text ;



