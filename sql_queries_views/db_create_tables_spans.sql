/*
 * FB, 3 March 2026
 * Rewritten the whole scripts and produced the tables
 * using the new data and structure
 * 
 */


-- inspect project entry
select *
from project_entry pe
where pe.annotation_automated is not null
limit 10;


/*
 * About the different kinds of spans: reference, head, etc.
 * cf. Annotation manual 2.2.1 : Reference
 * 
 */

-- first level span
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
-- the entryid is the main identifier of a text
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
)
select dossierid, entryid, year, span, 
-- there are strings in the @id, 
-- no cast to integer possible here
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
concat(entryid, '_span', (xpath('/span/@id', 
	span))[1]::text) as span_uri, 
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
	(xpath('/span/@start', 
	span))[1]::text as token_start,
	(xpath('/span/@end', 
	span))[1]::text as token_end,
	xpath('/span/span/@id', 
	span) as children,
	span, null as parent_span_id, dossierid, entryid
from tw1
order by span_id;


-- create table with all the spans
drop table t_spans CASCADE	;
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
 	--ROW_NUMBER() OVER ()::BIGINT AS pk_t_spans,
 	concat(entryid, '_span', (xpath('/span/@id', 
	span))[1]::text) as span_uri, 
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
	(xpath('/span/@start', 
	span))[1]::text as token_start,
	(xpath('/span/@end', 
	span))[1]::text as token_end,
	xpath('/span/span/@id', 
	span) as children, '' as parent_span_id,
	span, dossierid, entryid, pageid
from tw1
order by dossierid, year, entryid;


-- verify index types !!!
ALTER table t_spans add primary key (span_uri);
CREATE INDEX t_spans_class_index ON t_spans (span_class);
CREATE INDEX t_spans_norm_index ON t_spans (span_norm);
CREATE INDEX t_spans_span_text_idx ON t_spans (span_text);
CREATE INDEX t_spans_entryid_idx ON t_spans (entryid);

-- One can add two indexes on table
--CREATE INDEX USING GIN for trigrams


analyze public.t_spans;
vacuum public.t_spans;

select * 
from t_spans
--where entryid = 'bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
where entryid = '1a788909-9885-4bf2-9352-ac73fffabe4b_20250307'
order by span_id;
limit 200;


-- 28 May 2028: 2'569'255
select count(*) as number
from t_spans;



select *
from t_spans ts 
order by dossierid, year, span_id 
offset 200
limit 50;

select *
from t_spans ts 
limit 10;


alter table t_spans add column parent_span_uri text;


-- children with parents
select span_uri as parent_span_uri, span, unnest(children)::text::integer as child_id, span_id as parent_id, ts.dossierid, ts.entryid 
from t_spans ts 
where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
order by parent_id, child_id
limit 20;




-- add parents to child spans
-- we use for this the primary key of spans
-- and make joins more easy
with tw1 as (
select unnest(children)::text as child_id,
span_uri as parent_span_uri, span_id as parent_id, ts.entryid
from t_spans ts
)
update t_spans ts
set parent_span_uri = tw1.parent_span_uri, 
   parent_span_id = tw1.parent_id
   from tw1
where ts.span_id = tw1.child_id 
--and ts.dossierid = tw1.dossierid 
and  ts.entryid = tw1.entryid;


CREATE INDEX idx_t_spans_fk_parent_uri ON t_spans (parent_span_uri);


select * from 
t_spans ts 
where ts.parent_span_uri is null
limit 10;

-- the fk_parent_span column must be NULL if no reference (and not 0) 
-- in order to add this contraint because many spans do not have a parent span

ALTER TABLE t_spans ADD CONSTRAINT fk_t_spans_parent_span_uri
	FOREIGN KEY (parent_span_uri) REFERENCES t_spans(span_uri);



select *
from t_spans ts 
--where ts.entryid='bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
where ts.entryid='1a788909-9885-4bf2-9352-ac73fffabe4b_20250307'
--where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
--order by parent_id, child_id
limit 200;

-- verify parents
select ts.span_id, ts.span, ts.parent_span_id, parent_span.span_id, parent_span.span
from t_spans ts left join t_spans as parent_span
on ts.parent_span_uri = parent_span.span_uri
--where ts.entryid='bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
where ts.entryid='1a788909-9885-4bf2-9352-ac73fffabe4b_20250307'
--where ts.entryid = 'cc9e5200-8464-4de6-bca8-a65ea29ea72d_20250307'
--order by parent_id, child_id
limit 200;


/*
 * Explore
 */

select count(*)
from t_spans ts ;

-- 28 May 2026 : 694961
select count(*)
from t_spans ts 
where ts.span_element = 'reference';


select ts.span_element, count(*) number
from t_spans ts 
group by span_element 
order by number desc;



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


/*
 * Spans to tokens
*/

select * 
from t_spans
--where entryid = 'bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
where entryid = '1a788909-9885-4bf2-9352-ac73fffabe4b_20250307'
order by span_id;
limit 200;




-- tokens
select (unnest(xpath('//text/token/text()', 
pe.annotation_automated)))::text as token,
(unnest(xpath('//text/token/@token_id', 
pe.annotation_automated)))::text::integer as token_id,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null
order by year


with tw1 as (
-- tokens
select (unnest(xpath('//text/token/text()', 
pe.annotation_automated)))::text as token,
(unnest(xpath('//text/token/@token_id', 
pe.annotation_automated)))::text::integer as token_id,
--year, dossierid, 
--pageid, 
entryid
from project_entry pe 
--where pe.dossierid = 'HGB_1_002_026' 
where entryid = '1a788909-9885-4bf2-9352-ac73fffabe4b_20250307'
AND pe.annotation_automated is not null
)
select concat(entryid, '_tok', token_id::text) token_uri, token token_text, token_id, entryid
from tw1;




create table t_token as
with tw1 as (
select (unnest(xpath('//text/token/text()', 
pe.annotation_automated)))::text as token,
(unnest(xpath('//text/token/@token_id', 
pe.annotation_automated)))::text::integer as token_id,
entryid
from project_entry pe 
where pe.annotation_automated is not null
)
select concat(entryid, '_tok', token_id::text) token_uri, token token_text, token_id, entryid
from tw1;



ALTER table t_token add primary key (token_uri);
CREATE INDEX t_token_text_idx ON t_token(token_text);
CREATE INDEX t_token_entryid_idx ON t_token (entryid);

analyze public.t_token;
vacuum public.t_token;


-- explore
select *
from t_token
limit 10;

-- 28 May 2026: 4'984'355
select count(*)
from t_token;






-- generate link token -> spans
with tw1 as (
SELECT 
	span_id,
    generate_series(token_start::integer, token_end::integer) AS target,
    --token_start, token_end, 
    entryid 
FROM t_spans
--where entryid = 'bfe0d71e-df8d-448d-89ad-f208e760865e_20250307'
where entryid = '1a788909-9885-4bf2-9352-ac73fffabe4b_20250307'
)
select concat(entryid, '_span', span_id) as span_uri, 
concat(entryid, '_tok', target) as token_uri
from tw1;

    
    







