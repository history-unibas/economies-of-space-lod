

select *
from project_entry pe
where pe.annotation is not null
limit 10;


-- first level reference span
select unnest(xpath('//myns:span', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation is not null;


with tw1 as (
select unnest(xpath('//myns:span', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation is not null
)
select dossierid, entryid, year, span, 
	(xpath('/myns:span/@id', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_id
from tw1;	


-- 
with tw1 as (
select unnest(xpath('//myns:span', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation is not null
)
select year, 
	(xpath('/myns:span/@text', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_text,
	(xpath('/myns:span/@class', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_class,
	(xpath('/myns:span/@element', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_element,
	(xpath('/myns:span/@id', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_id,
	xpath('/myns:span/myns:span/@id', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])) as children,
	span, dossierid, entryid
from tw1;




-- create table with spans
drop table t_spans	;
create table t_spans as
with tw1 as (
select unnest(xpath('//myns:span', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as span,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.annotation is not null
)
select year, 
	(xpath('/myns:span/@text', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_text,
	(xpath('/myns:span/@class', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_class,
	(xpath('/myns:span/@element', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_element,
	(xpath('/myns:span/@id', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as span_id,
	'' as parent_span_id,
	span, dossierid, entryid,
	xpath('/myns:span/myns:span/@id', 
	span, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))::text[] as children
from tw1;


select *
from t_spans ts 
limit 20;


-- childres with parents
select distinct unnest(children)::text as child_id, span_id as parent_id, ts.dossierid, ts.entryid 
from t_spans ts 
where span_id > '1508'
order by parent_id, child_id
limit 20;



-- empty column to be sure
update t_spans ts
set parent_span_id = null;


-- add parents to child spans
with tw1 as (select unnest(children)::text as child_id, span_id as parent_id, ts.dossierid, ts.entryid
from t_spans ts)
update t_spans ts
set parent_span_id = tw1.parent_id
from tw1
where ts.span_id = tw1.child_id 
and ts.dossierid = tw1.dossierid 
and  ts.entryid = tw1.entryid;


select *
from t_spans ts 
where ts.dossierid = 'HGB_1_002_026'
order by span_id 
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
where ts.span_class = 'fac'
order by span_text ;


select ga.adresse, ga.eigent1862, ga.hausname, ts.*
from t_spans ts 
	join project_dossier pd on pd.dossierid = ts.dossierid 
	join stabs_dossier sd on sd.dossierid = pd.dossierid 
	join geo_address ga on ga.signatur = sd.stabsid 
where ts.span_class = 'fac'
order by span_text ;