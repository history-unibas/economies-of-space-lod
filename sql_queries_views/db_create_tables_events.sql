
/*
 * 
 * New column 'annotationautomated' without array, just XML value
 *  
 */

-- event groups XML

select unnest(xpath('//eventGroup', 
pe.annotationautomated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.entryid = '37685ccb-3ae4-4c72-9248-b31c0311bf16_20260528'
--where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotationautomated is not null;


/*
* Number of events per event group
*
* There are up to 12 events per event group, more often 2, 3 or 4
* This demands to have a dedicated table for events
*/

with tw1 as (
select unnest(xpath('//eventGroup', 
pe.annotationautomated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where --pe.entryid = 'd7cb61aa-3215-49e3-b802-80a4540f35d6_20250307'
--where pe.annotationautomated is not null
--and 
pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('eventGroup/@event_id', 
event_group))[1]::text ev_gr_id,
	array_length(xpath('eventGroup/event', 
event_group), 1) events_count,
	event_group, year, dossierid, pageid, entryid
from tw1
order by dossierid, entryid, ev_gr_id
;




-- event group with properties

with tw1 as (
select unnest(xpath('//eventGroup', 
pe.annotationautomated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotationautomated is not null
and -- pe.entryid = 'd7cb61aa-3215-49e3-b802-80a4540f35d6_20250307'
pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('eventGroup/@class', 
event_group))[1]::text ev_gr_class,
	(xpath('eventGroup/@type', 
event_group))[1]::text ev_gr_type,
	(xpath('eventGroup/@event_id', 
event_group))[1]::text::integer ev_gr_id,
	(xpath('eventGroup/@ref', 
event_group))[1]::text ev_gr_ref,
	(xpath('eventGroup/@start', 
event_group))[1]::text ev_gr_start,
	(xpath('eventGroup/@end', 
event_group))[1]::text ev_gr_end,
/*	
 * (xpath('eventGroup/@polarity', 
event_group))[1]::text ev_gr_polarity,
	(xpath('eventGroup/@tense', 
event_group))[1]::text ev_gr_tense,
	(xpath('eventGroup/@modality', 
event_group))[1]::text ev_gr_modality,
*/
-- 'résuppose que le trigger soit unique par eventGroup'
	(xpath('eventGroup/trigger/@text', 
event_group))[1]::text ev_gr_trigger_text,
	(xpath('eventGroup/trigger/@ref', 
event_group))[1]::text ev_gr_trigger_ref,
	(xpath('eventGroup/event', 
event_group)) event,
	event_group, year, dossierid, pageid, entryid
from tw1;




/*
 * CREATE TABLE for event group with properties
 */

--drop table t_event_group_with_properties;

create table t_event_group_with_properties AS
with tw1 as (
select unnest(xpath('//eventGroup', 
pe.annotationautomated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotationautomated is not null
)
select 
	(xpath('eventGroup/@class', 
event_group))[1]::text ev_gr_class,
(xpath('eventGroup/@type', 
event_group))[1]::text ev_gr_type,
	(xpath('eventGroup/@event_id', 
event_group))[1]::text ev_gr_id,
	(xpath('eventGroup/@ref', 
event_group))[1]::text ev_gr_ref,
	(xpath('eventGroup/@start', 
event_group))[1]::text ev_gr_start,
	(xpath('eventGroup/@end', 
event_group))[1]::text ev_gr_end,
-- 'résuppose que le trigger soit unique par eventGroup'
	(xpath('eventGroup/trigger/@text', 
event_group))[1]::text ev_gr_trigger_text,
	(xpath('eventGroup/trigger/@ref', 
event_group))[1]::text ev_gr_trigger_ref,
	(xpath('eventGroup/event', 
event_group)) event,
	event_group, year, dossierid, pageid, entryid
from tw1
order by dossierid, entryid, ev_gr_id;


CREATE INDEX ev_gr_class_index ON t_event_group_with_properties (ev_gr_class);
CREATE INDEX ev_gr_type_index ON t_event_group_with_properties (ev_gr_type);
CREATE INDEX ev_gr_entryid_index ON t_event_group_with_properties (entryid);


select count(*) as num
from t_event_group_with_properties;


-- inspect
select *
from t_event_group_with_properties
offset 500
limit 30;


/*
 * Create a primary key for this table
 */

select concat(entryid, '_evgr', ev_gr_id) pk_t_event_group
from t_event_group_with_properties  
limit 10;


-- add primary key
alter table t_event_group_with_properties add column pk_t_event_group TEXT;
update t_event_group_with_properties set pk_t_event_group = concat(entryid::text, '_evgr', ev_gr_id);
alter table t_event_group_with_properties add primary key (pk_t_event_group);






/*
 * Explore data summarily
 * 
 */


-- year
select year, count(*) as number
from t_event_group_with_properties
group by year
order by year;

-- class
select ev_gr_class, count(*) as number
from t_event_group_with_properties
group by ev_gr_class 
order by number desc;

-- type : distinction between states and events
select ev_gr_type, count(*) as number
from t_event_group_with_properties
group by ev_gr_type 
order by number desc;

-- class and type
select ev_gr_class, ev_gr_type, count(*) as number
from t_event_group_with_properties
group by ev_gr_class, ev_gr_type
order by ev_gr_class, ev_gr_type ;





/*
 * Add event group classes
 */

select ROW_NUMBER() OVER ()::BIGINT AS pk_event_group_class,
ev_gr_class, count(*) as num
from t_event_group_with_properties
group by ev_gr_class 
order by num desc;

drop table t_event_group_class ;
create table t_event_group_class as 
select ROW_NUMBER() OVER ()::BIGINT AS pk_event_group_class,
ev_gr_class, count(*) as num
from t_event_group_with_properties
group by ev_gr_class;

ALTER table t_event_group_class add primary key (pk_event_group_class);

select * 
from t_event_group_class;



alter table t_event_group_with_properties add column fk_event_group_class integer;


select t1.*, t2.ev_gr_class, t2.*
from t_event_group_class t1, t_event_group_with_properties t2
where t1.ev_gr_class= t2.ev_gr_class
limit 10;

update  t_event_group_with_properties t2
	set fk_event_group_class = t1.pk_event_group_class
from t_event_group_class t1
where t1.ev_gr_class= t2.ev_gr_class;


CREATE INDEX t_pk_event_group_class_fk_event_group_class 
ON t_event_group_with_properties (fk_referenced_objects_class);








/*
 * Produce events table
 */

-- select events

select 
	unnest(xpath('//event', 
event_group)) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from t_event_group_with_properties
where dossierid = 'HGB_1_002_026'
offset 50
limit 20;


with tw1 as (
select 
	unnest(xpath('//event', 
event_group)) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from t_event_group_with_properties
where dossierid = 'HGB_1_002_026'
limit 20)
select
	concat(entryid, '_ev', replace((xpath('event/@event_id', 
event))[1]::text, '.', '-')) event_uri,
	replace((xpath('event/@event_id', 
event))[1]::text, '.', '-') as event_id,
concat(entryid::text, '_evgr', ev_gr_id) as fk_event_group,
	event, 
	array_length(xpath('//event', 
event_group),1) as ev_gr_length,
	ev_gr_id, year, dossierid, pageid, entryid
from tw1
order by dossierid, entryid, ev_gr_id ;





/*
 * CREATE TABLE for events with id
 */

drop table t_event_with_id;
create table t_event_with_id as
with tw1 as (
select 
	unnest(xpath('//event', 
event_group)) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from t_event_group_with_properties
)
select
	concat(entryid, '_ev', replace((xpath('event/@event_id', 
event))[1]::text, '.', '-')) event_uri,
	replace((xpath('event/@event_id', 
event))[1]::text, '.', '-') as event_id,
concat(entryid::text, '_evgr', ev_gr_id) as fk_event_group,
	event, 
	array_length(xpath('//event', 
event_group),1) as ev_gr_length,
	--event_group, 
	ev_gr_id, year, dossierid, pageid, entryid
from tw1
order by dossierid, entryid, ev_gr_id ;


ALTER table t_event_with_id add primary key (event_uri);


-- inspect
select substring(event_id FROM '-(.*)') event_own_id, *
from t_event_with_id
where ev_gr_length > 1
limit 50;


-- test join with event group

select ev.fk_event_group, ev.ev_gr_id, ev.event_uri,
 substring(event_id FROM '-(.*)')::integer event_own_id,
		ev.event_id, ev_gr_length, evg.ev_gr_class, ev.year, ev.event, evg.event_group, evg.entryid
from t_event_with_id ev, t_event_group_with_properties evg
where ev_gr_length > 1  
and ev.fk_event_group = evg.pk_t_event_group
limit 50;


-- add foreign key
ALTER TABLE t_event_with_id ADD CONSTRAINT fk_t_event_group_with_properties
	FOREIGN KEY (fk_event_group) REFERENCES t_event_group_with_properties(pk_t_event_group);


select *
from t_event_with_id tewi 
limit 10;


/*
 * Add roles table
 * 
 */
 
-- inspect
select unnest(xpath('//role', 
event)) as role, 
substring(event_id FROM '-(.*)')::int event_own_id, 
ev_gr_id, event_id, ev_gr_length,
event, year,dossierid,pageid,entryid
from t_event_with_id
--where ev_gr_length > 1
limit 50;

-- roles with properties
with tw1 as (
select event_uri, unnest(xpath('//role', 
event)) as role, 
substring(event_id FROM '-(.*)')::int event_own_id, 
ev_gr_id, event_id, ev_gr_length,
event, year,dossierid,pageid,entryid
from t_event_with_id
where dossierid = 'HGB_1_002_026'
and ev_gr_length > 1
limit 100)
select
	event_uri,
	ev_gr_id, concat(event_uri, '_role',(ROW_NUMBER() OVER ()::BIGINT)::text) AS role_uri,
	(xpath('role/@ref', 
role))[1]::text as role_ref,
	(xpath('role/@role', 
role))[1]::text as role_role,
	(xpath('role/@text', 
role))[1]::text as role_text,
	role, 
	event,
	ev_gr_length,
	event_id, year, entryid
from tw1
order by entryid, ev_gr_id, event_own_id ;




/*
 * CREATE TABLE for roles 
 */

drop table t_role;
create table t_role as
with tw1 as (
select event_uri, unnest(xpath('//role', 
event)) as role, 
substring(event_id FROM '-(.*)')::int event_own_id, 
ev_gr_id, event_id, ev_gr_length,
event, year,dossierid,pageid,entryid
from t_event_with_id)
select
	event_uri,
	ev_gr_id, concat(event_uri, '_role',(ROW_NUMBER() OVER ()::BIGINT)::text) AS role_uri,
	substring(event_id FROM '-(.*)')::int event_own_id,
	concat(entryid, '_span', (xpath('role/@ref', 
role))[1]::text) as fk_span_uri, 
	(xpath('role/@ref', 
role))[1]::text as role_ref,
	(xpath('role/@role', 
role))[1]::text as role_role,
	(xpath('role/@text', 
role))[1]::text as role_text,
	role, 
	event,
	ev_gr_length,
	event_id, year, entryid
from tw1
order by entryid, ev_gr_id, event_own_id ;


ALTER table t_role add primary key (role_uri);


CREATE INDEX t_role_role_index ON t_role (role_role);
CREATE INDEX t_role_entryid_index ON t_role (entryid);
CREATE INDEX t_role_ev_gr_id_index ON t_role (ev_gr_id);

-- add foreign key
ALTER TABLE t_role ADD CONSTRAINT fk_t_event_with_id
	FOREIGN KEY (event_uri) REFERENCES t_event_with_id(event_uri);


CREATE INDEX idx_t_role_fk_t_span ON t_role (fk_span_uri);

-- not possible error in data
-- fk_span_uri)=(ffb930a1-b9d8-487a-9005-9911b0f9af4d_20260528_spanE_work_stattgraben)
ALTER TABLE t_role ADD CONSTRAINT t_role_fk_t_spans 
	FOREIGN KEY (fk_span_uri) REFERENCES t_spans(span_uri);

-- inspect

select *
from t_role
--where ev_length > 3
--order by entryid, ev_gr_id, event_id, role_ref
offset 2000
limit 200;







/*
 *   Partie précédente--- élimiter ? 
 */

-- test join with event group, event and role

select ev.ev_gr_id, ev.ev_gr_length, ev.event_id, evg.dossierid, evg.ev_gr_class, ev.year, 
rol.role_role, rol.role_text,
evg.event_group, evg.entryid
from v_event_with_id ev, v_event_group_with_properties evg, v_role as rol
where ev_gr_length > 2
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
and rol.entryid = evg.entryid
and rol.event_id = ev.event_id
and rol.ev_gr_id = ev.ev_gr_id
and rol.ev_length > 3
and rol.ev_length < 8
limit 50;







-- test t_roles_with_events

select *
from t_roles_with_events
where ev_gr_length > 3
order by entryid, ev_gr_id, event_id, role_ref
limit 200;





select role_role, count(*) as number
from t_roles_with_events
group by role_role
order by number desc;


select ev_gr_class, role_role, count(*) as number
from t_roles_with_events
group by ev_gr_class,role_role
order by number desc;


select ev_gr_class, count(*) as number
from t_roles_with_events
group by ev_gr_class
order by number desc;



with tw1 as (
select ev_gr_class, role_role, count(*) as role_number
from t_roles_with_events
group by ev_gr_class,role_role),
tw2 as (
select ev_gr_class, count(*) as class_number
from t_roles_with_events
group by ev_gr_class)
select tw2.ev_gr_class, tw2.class_number, 
tw1.role_role, tw1.role_number
from tw2, tw1
where tw1.ev_gr_class = tw2.ev_gr_class
order by class_number desc, role_number desc;







/*
 * add a foreign key to spans
 */



select eg.event_group, tr.*, ts.*
from t_role tr, t_spans ts, t_event_group_with_properties eg 
where tr.entryid = '01ffb7e6-55d7-4743-9b25-da209a8da3d0_20250307'
and eg.pk_t_event_group = tr.fk_t_event_group 
and ts.span_id = tr.role_ref 
and ts.entryid = tr.entryid 
order by role_ref::integer ;





-- add foreign key
alter table t_role add column fk_t_span BIGINT;

update t_role tr set fk_t_span = ts.pk_t_spans 
from t_spans ts 
where ts.entryid = tr.entryid
and ts.span_id = tr.role_ref;


CREATE INDEX idx_t_role_fk_t_span ON t_role (fk_t_span);
ALTER TABLE t_role ADD CONSTRAINT t_role_fk_t_spans 
	FOREIGN KEY (fk_t_span) REFERENCES t_spans(pk_t_spans);


analyze public.t_role;
vacuum public.t_role;





