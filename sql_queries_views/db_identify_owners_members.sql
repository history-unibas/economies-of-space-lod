
select *
from t_spans ts 
limit 200;


-- inspect owners
select tr.entryid, tr.role_text,
		ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year, ts1.span_element, -- ts1.span_norm ,
		eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	-- the owner as a person
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the owner span
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
		and ts.span_class='per'
	-- the name of the owner
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'ownership'
and tr.role_role = 'owner'
order by ts.span_text 
offset 100
limit 100;



-- prepare owners
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'owner' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	-- the owner as a person
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the owner span
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
		and ts.span_class='per'
	-- the name of the owner
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'ownership'
and tr.role_role = 'owner'
order by ts1.span_text 
offset 100
limit 100;



-- inspect members
select tr.entryid, tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, 
		ts.span_text, eg."year", ts.span_class, ts.span_norm ,
		eg.ev_gr_trigger_ref,
		eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg, 
	t_role tr, t_spans ts 
where eg.ev_gr_class = 'membership'
and tr.fk_t_event_group = eg.pk_t_event_group 
and ts.pk_t_spans = tr.fk_t_span 
and ts.span_class='per'
and tr.role_role = 'member'
order by ts.span_text 
offset 100
limit 100;







-- prepare members
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'member' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the member as person
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
	and ts.span_class='per'
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'membership'
and tr.role_role = 'member'
order by ts1.span_text 
offset 100
limit 100;




/*
* Join members and owners 
* and count
*/


select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'owner' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	-- the owner as a person
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the owner span
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
		and ts.span_class='per'
	-- the name of the owner
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'ownership'
and tr.role_role = 'owner'
union 
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'member' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the member as person
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
	and ts.span_class='per'
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'membership'
and tr.role_role = 'member'
order by span_text 
offset 150
limit 150;


-- count and inspect: persons appear !
with tw1 as (
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'owner' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	-- the owner as a person
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the owner span
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
		and ts.span_class='per'
	-- the name of the owner
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'ownership'
and tr.role_role = 'owner'
union 
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'member' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the member as person
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
	and ts.span_class='per'
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'membership'
and tr.role_role = 'member'
)
select lower(trim(span_text)) AS span_text, min(year) as min_year, max(year) as max_year, string_agg(distinct year::text, ','), string_agg(distinct p_role , ','), count(*) as num
from tw1
group by lower(trim(span_text))
order by num desc 
offset 200
limit 200;

select *
from t_spans ts 
limit 10;

drop table t_analyis_owners_members;
create table t_analyis_owners_members AS
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'owner' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	-- the owner as a person
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the owner span
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
		and ts.span_class='per'
	-- the name of the owner
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'ownership'
and tr.role_role = 'owner'
union 
select tr.entryid, tr.role_text,
		--ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, eg.year , 'member' as p_role,
		ts.pk_t_spans
		--ts1.span_element, -- ts1.span_norm ,
		-- eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg 
	join t_role tr on tr.fk_t_event_group = eg.pk_t_event_group 
	-- the member as person
	join t_spans ts on ts.pk_t_spans = tr.fk_t_span 
	and ts.span_class='per'
	join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
		and ts1.span_class='nam'
where eg.ev_gr_class = 'membership'
and tr.role_role = 'member'
order by span_text ;


select *
from t_analyis_owners_members 
offset 300
limit 200;

-- possibly not needed
--CREATE INDEX t_analyis_owners_members_span_text_trgm ON t_analyis_owners_members 
			USING GIN (lower(trim(span_text)) gin_trgm_ops);

CREATE INDEX t_analyis_owners_members_span_text ON t_analyis_owners_members (span_text);





select count(*) as num, lower(trim(span_text)) span_text, min(year) as min_year, max(year) as max_year, 
				string_agg(distinct year::text, ',') as years, string_agg(distinct p_role , ',') as names,
				array_agg(pk_t_spans) pk_spans, string_agg(distinct entryid , ',') as entryids 
from t_analyis_owners_members
group by lower(trim(span_text))
having count(*) < 24
order by num desc 
--offset 2000
limit 100;


select count(*)
from t_analyis_owners_members;

-- create new aggregated table
drop table t_analyis_owners_members_grdp;
create table t_analyis_owners_members_grdp as
select ROW_NUMBER() OVER ()::BIGINT AS pk_ow_mem_grpd,
count(*) as num, lower(trim(span_text)) span_text, min(year) as min_year, max(year) as max_year, 
				string_agg(distinct year::text, ',') as years, string_agg(distinct p_role , ',') as names,
				array_agg(pk_t_spans) pk_spans, string_agg(distinct entryid , ',') as entryids 
from t_analyis_owners_members
group by lower(trim(span_text))
having count(*) < 24
order by num desc ;

select count(*)
from t_analyis_owners_members_grdp;

select *
from t_analyis_owners_members_grdp
offset 1000 
limit 10;

CREATE INDEX t_analyis_owners_members_grpd_span_text_trgm ON t_analyis_owners_members_grdp 
			USING GIN (lower(trim(span_text)) gin_trgm_ops);

CREATE INDEX t_analyis_owners_members_grdp_span_text ON t_analyis_owners_members_grdp (span_text);


select *
from t_analyis_owners_members_grdp
order by num desc
offset 100
limit 200;



with tw1 as (
select *
from t_analyis_owners_members_grdp
order by num desc
offset 100
limit 1000)
SELECT
    a.pk_ow_mem_grpd,
    a.span_text,
    b.pk_ow_mem_grpd AS match_id,
    b.span_text AS match_span_text,
    -- not suitable
    --strict_word_similarity(lower(trim(a.span_text)), lower(trim(b.span_text))) AS score
    similarity(lower(trim(a.span_text)), lower(trim(b.span_text))) AS score
FROM tw1 a
JOIN tw1 b
    ON a.pk_ow_mem_grpd < b.pk_ow_mem_grpd  -- avoid duplicate pairs
WHERE similarity(a.span_text, b.span_text) > 0.7
--WHERE strict_word_similarity(a.span_text, b.span_text) > 0.7
ORDER BY score desc
limit 200;


-- first similarity level
--drop table t_analyis_owners_members_first_level_similarity ; 
create table t_analyis_owners_members_first_level_similarity AS 
with tw1 as (
select *
from t_analyis_owners_members_grdp
order by num desc
),
similarity_pairs AS (
    SELECT
    a.pk_ow_mem_grpd as id1,
    b.pk_ow_mem_grpd AS id2
FROM tw1 a
JOIN tw1 b
    ON a.pk_ow_mem_grpd < b.pk_ow_mem_grpd  -- avoid duplicate pairs
    and similarity(lower(trim(a.span_text)), lower(trim(b.span_text))) > 0.7
),
-- Build a union-find style grouping using transitive closure
clustered AS (
    SELECT DISTINCT
        LEAST(id1, id2)    AS canonical_id,
        GREATEST(id1, id2) AS member_id
    FROM similarity_pairs
)
SELECT
    o.pk_ow_mem_grpd,
    o.span_text,
    COALESCE(c.canonical_id, o.pk_ow_mem_grpd) AS group_id
FROM tw1 o
LEFT JOIN clustered c ON o.pk_ow_mem_grpd = c.member_id
ORDER BY group_id;

-- inspect
select *
from  t_analyis_owners_members_first_level_similarity
offset 20
limit 200;

select count(*) as num
from  t_analyis_owners_members_first_level_similarity;

select count(*)
from t_analyis_owners_members;

select count(*)
from t_analyis_owners_members_grdp;


select group_id, count(*) as num, string_agg(span_text, ', ') spans
from t_analyis_owners_members_first_level_similarity
group by group_id
order by num desc;

select group_id, t1.span_text, ts.span_text, t1.num,  t1.min_year, t1.max_year, ts.pk_ow_mem_grpd 
 from  t_analyis_owners_members_first_level_similarity ts
  join t_analyis_owners_members_grdp t1 on t1.pk_ow_mem_grpd = ts.pk_ow_mem_grpd 
  where t1.num > 1
  order by t1.span_text 
limit 200;



drop table t_person;
CREATE TABLE t_person (
    pk_person    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT           NOT NULL,
    description       TEXT,
    notes       TEXT,
    join_name   TEXT,
    group_id bigint,
    deprecated_in_favor_of INT   references t_person (pk_person), -- points toward preferred person
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT now()
);



--insert into t_person (name, join_name, group_id)
select span_text, span_text, group_id 
 from  t_analyis_owners_members_first_level_similarity
 where group_id = pk_ow_mem_grpd 
 order by span_text;
 limit 100;



select *
from t_person
limit 100;

select count(*)
from t_person
limit 100;




select *
from t_analyis_owners_members 
offset 500
limit 100;


select count(*)
from t_analyis_owners_members ;

select count(*)
from t_analyis_owners_members_grdp ;


select *
from  t_analyis_owners_members_first_level_similarity ts
order by group_id 
offset 20
limit 20;


-- group and count
select ts.group_id, string_agg(ts.span_text, ', '), count(*) as num, array_agg(ts.pk_ow_mem_grpd)
from t_analyis_owners_members_first_level_similarity ts
group by ts.group_id 
order by num desc
;


-- inspect matched similarity groups
select  t1.span_text,ts.span_text stand_name, t1.min_year, t1.max_year, group_id, ts.pk_ow_mem_grpd grpd_id, t1.num   
from  t_analyis_owners_members_first_level_similarity ts
join t_analyis_owners_members_grdp t1 on t1.pk_ow_mem_grpd = ts.pk_ow_mem_grpd 
where group_id in (select ts.group_id
from t_analyis_owners_members_first_level_similarity ts
group by ts.group_id 
having count(*) > 3
)
--order by t1.span_text 
order by group_id, ts.pk_ow_mem_grpd 
offset 48
limit 200;



-- unnest inspect matched similarity groups
select  t1.span_text,ts.span_text stand_name, t1.min_year, t1.max_year, 
group_id, ts.pk_ow_mem_grpd grpd_id, unnest(t1.pk_spans) as pk_t_spans , t1.num   
from  t_analyis_owners_members_first_level_similarity ts
join t_analyis_owners_members_grdp t1 on t1.pk_ow_mem_grpd = ts.pk_ow_mem_grpd 
where group_id in (select ts.group_id
from t_analyis_owners_members_first_level_similarity ts
group by ts.group_id 
having count(*) > 3
)
--order by t1.span_text 
order by group_id, ts.pk_ow_mem_grpd 
offset 48
limit 200;



-- inspection with original data and persons
with tw1 as
(select t1.span_text,ts.span_text stand_name, t1.min_year, t1.max_year, 
group_id, ts.pk_ow_mem_grpd grpd_id, unnest(t1.pk_spans) as pk_t_spans , t1.num   
from t_analyis_owners_members_first_level_similarity ts
join t_analyis_owners_members_grdp t1 
 	on t1.pk_ow_mem_grpd = ts.pk_ow_mem_grpd 
where group_id in (select ts.group_id
from t_analyis_owners_members_first_level_similarity ts
group by ts.group_id 
-- most frequent
having count(*) > 2)
offset 48
limit 200)
select tp.pk_person as pk_p, tw1.group_id as gr_id, tp."name", tom.span_text, tom.year, 
	concat(tw1.min_year::text, '-', tw1.max_year::text), tom.role_text, tom.p_role, 
	tw1.num grp_num, tw1.pk_t_spans --,tw1.*
from t_person tp 
join tw1 
	on tp.group_id = tw1.group_id 
join t_analyis_owners_members tom
	on tom.pk_t_spans = tw1.pk_t_spans 
order by tp.pk_person, year ;
