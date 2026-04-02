/*
 * We use here the normalized group appellation in the spans
 * to create a table of provisionally identified groups
 */


-- inspect spans of type org
SELECT *
FROM t_spans ts 
where ts.span_class = 'org'
LIMIT 10;

-- inspect normalized orgs
SELECT ts2.span_norm, ts2.fk_parent_span 
FROM t_spans ts join t_spans ts2 on ts2.fk_parent_span = ts.pk_t_spans 
where ts.span_class = 'org'
and ts2.span_class = 'nam'
offset 100
LIMIT 10;

-- count normalized orgs
SELECT lower(trim(ts2.span_norm)) group_norm, count(*) as num
FROM t_spans ts join t_spans ts2 on ts2.fk_parent_span = ts.pk_t_spans 
where ts.span_class = 'org'
and ts2.span_class = 'nam'
group by lower(trim(ts2.span_norm))
order by lower(trim(ts2.span_norm));
order by num desc;
LIMIT 10;




-- count occurrences of groups present in spans, in attribute 'norm'
SELECT ts2.span_norm, ts2.span_class, count(*) as num
FROM t_spans ts join t_spans ts2 
	on ts2.fk_parent_span = ts.pk_t_spans
where ts.span_class = 'org'
and ts2.span_class = 'nam'
--and ts2.span_norm ~* 'stif'
and ts2.span_norm ~* 'kloster'
group by ts2.span_norm, ts2.span_class
order by span_norm ;




--drop table t_group;
CREATE TABLE t_group (
    pk_group    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT           NOT NULL,
    description       TEXT,
    notes       TEXT,
    join_name   TEXT,
    number_of_spans_at_creation INT,
    deprecated_in_favor_of INT        REFERENCES t_group(pk_group), -- points toward preferred group
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT now()
);


select *
from t_group;

-- fill table group with normalized groups
insert into t_group ("name", join_name, number_of_spans_at_creation )
SELECT lower(trim(ts2.span_norm)), lower(trim(ts2.span_norm)), count(*) as num
FROM t_spans ts join t_spans ts2 on ts2.fk_parent_span = ts.pk_t_spans 
where ts.span_class = 'org'
and ts2.span_class = 'nam'
group by lower(trim(ts2.span_norm))
order by lower(trim(ts2.span_norm));


-- inspect normalized orgs
SELECT ts.span_text, ts2.span_norm, tg.join_name, tg.pk_group , ts2.fk_parent_span, ts2.pk_t_spans 
FROM t_spans ts 
	join t_spans ts2 on ts2.fk_parent_span = ts.pk_t_spans 
	join t_group tg on tg.join_name = lower(trim(ts2.span_norm))
where ts.span_class = 'org'
and ts2.span_class = 'nam'
offset 100
LIMIT 10;

--create join table
create table t_group_span as
SELECT ts.span_text, ts2.span_norm, tg.join_name, tg.pk_group , ts2.fk_parent_span, ts2.pk_t_spans 
FROM t_spans ts 
	join t_spans ts2 on ts2.fk_parent_span = ts.pk_t_spans 
	join t_group tg on tg.join_name = lower(trim(ts2.span_norm))
where ts.span_class = 'org'
and ts2.span_class = 'nam';

/*
 * Augustiner Kloster - väter : the same ?
 */

select * 
from t_group_span
order by join_name, span_norm
offset 1000
limit 200;



