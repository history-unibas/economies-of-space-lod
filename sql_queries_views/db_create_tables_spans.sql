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
	span))[1]::text as span_id
from tw1
order by dossierid, year, entryid, span_id;	


-- extract all relevant attributes from all levels spans
-- and prepare CREATE TABLE query
with tw1 as (
select unnest(xpath('//span', 
pe.annotation_automated)) as span,
year, dossierid, 
pageid, 
entryid
from project_entry pe 
--where pe.dossierid = 'HGB_1_002_026' 
where entryid='bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
AND pe.annotation_automated is not null
)
select ROW_NUMBER() OVER ()::BIGINT AS pk_t_spans,
year, 
	(xpath('/span/@text', 
	span))[1]::text as span_text,
	(xpath('/span/@class', 	
	span))[1]::text as span_class,
	(xpath('/span/@norm', 
	span))[1]::text as span_norm,
	(xpath('/span/@element', 
	span))[1]::text as span_element,
	(xpath('/span/@id', 
	span))[1]::text as span_id,
	xpath('/span/span/@id', 
	span) as children,
	span, null as parent_span_id, dossierid, entryid
from tw1
order by span_id;


-- create table with all the spans
drop table t_spans	;
create table t_spans as
with tw1 as (
select unnest(xpath('//span', 
pe.annotation_automated)) as span,
year, dossierid, 
pageid, 
entryid
from project_entry pe 
where pe.annotation_automated is not null
)
select 
 	ROW_NUMBER() OVER ()::BIGINT AS pk_t_spans,
 	year, 
	(xpath('/span/@text', 
	span))[1]::text as span_text,
	(xpath('/span/@class', 	
	span))[1]::text as span_class,
	(xpath('/span/@norm', 
	span))[1]::text as span_norm,
	(xpath('/span/@element', 
	span))[1]::text as span_element,
	(xpath('/span/@id', 
	span))[1]::text as span_id,
	xpath('/span/span/@id', 
	span) as children,
	span, 
	0 as fk_parent_span,
	'' as parent_span_id, dossierid, entryid, pageid
from tw1
order by dossierid, year, entryid;

alter table t_spans add primary key (pk_t_spans);
CREATE INDEX t_spans_class_index ON t_spans (span_class);
CREATE INDEX t_spans_norm_index ON t_spans (span_norm);
CREATE INDEX t_spans_span_text_idx ON t_spans (span_text);
CREATE INDEX t_spans_entryid_idx ON t_spans (entryid);

-- One can add towho indexes on table
--CREATE INDEX USING GIN for trigrams


analyze public.t_spans;
vacuum public.t_spans;

select * 
from t_spans
where entryid = 'bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
order by span_id;
limit 200;



select count(*) as number
from t_spans;


select *
from t_spans ts 
order by dossierid, year, span_id 
offset 200
limit 50;

-- empty column !!!
--update t_spans ts
set parent_span_id = null;


-- children with parents
select pk_t_spans as fk_t_spans, span, unnest(children)::text::integer as child_id, span_id as parent_id, ts.dossierid, ts.entryid 
from t_spans ts 
where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
order by parent_id, child_id
limit 20;




-- add parents to child spans
-- we use for this the primary key of spans
-- and make joins more easy
with tw1 as (
select unnest(children)::text as child_id,
pk_t_spans, span_id as parent_id, ts.dossierid, ts.entryid
from t_spans ts)
update t_spans ts
set fk_parent_span = tw1.pk_t_spans
from tw1
where ts.span_id = tw1.child_id 
and ts.dossierid = tw1.dossierid 
and  ts.entryid = tw1.entryid;


CREATE INDEX idx_t_spans_fk_parent_span ON t_spans (fk_parent_span);

-- you cannot add this contraint because many spans do not have a parent span
-- ALTER TABLE t_spans ADD CONSTRAINT fk_t_spans_parent_span 
	FOREIGN KEY (fk_parent_span) REFERENCES t_spans(pk_t_spans);



select *
from t_spans ts 
where ts.entryid='bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
--where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
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



