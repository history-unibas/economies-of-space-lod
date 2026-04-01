
/*
 * 
 * New column 'annotation_automated' without array, just XML value
 *  
 */

-- event groups XML

select unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
--where pe.entryid = 'd7cb61aa-3215-49e3-b802-80a4540f35d6_20250307'
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation_automated is not null;


/*
* Number of events per event group
*
* There are up to 12 events per event group, more often 2, 3 or 4
* This demands to have a dedicated table for events
*/

with tw1 as (
select unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where --pe.entryid = 'd7cb61aa-3215-49e3-b802-80a4540f35d6_20250307'
--where pe.annotation_automated is not null
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
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation_automated is not null
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
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation_automated is not null
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

/***
 * Create a primary key for this table
 */

-- document id and entry id appear to be functionally linked

-- To verify that each value in column entryid maps to exactly one value in column pageid 
-- i.e., the pairs of values are functionally unique
SELECT 
    entryid,
    COUNT(DISTINCT pageid ) AS distinct_pageid_count
FROM t_event_group_with_properties
GROUP BY entryid 
HAVING COUNT(DISTINCT pageid) > 1;

-- and the opposite
SELECT 
    pageid,
    COUNT(DISTINCT entryid ) AS distinct_entryid_count
FROM t_event_group_with_properties
GROUP BY pageid 
HAVING COUNT(DISTINCT entryid) > 1;


select concat(entryid, '_', ev_gr_id) pk_t_event_group
from t_event_group_with_properties  
limit 10;


-- add primary key
alter table t_event_group_with_properties add column pk_t_event_group TEXT;
update t_event_group_with_properties set pk_t_event_group = concat(entryid::text, '_', ev_gr_id);
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
	replace((xpath('event/@event_id', 
event))[1]::text, '.', '-') as event_id,
	event, 
	array_length(xpath('//event', 
event_group),1) as ev_gr_length,
	--event_group, 
	ev_gr_id, year, dossierid, pageid, entryid
from tw1
order by dossierid, entryid, ev_gr_id ;





/*
 * CREATE TABLE for events with id
 */

drop view t_event_with_id;

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
	replace((xpath('event/@event_id', 
event))[1]::text, '.', '-') as event_id,
	event, 
	array_length(xpath('//event', 
event_group),1) as ev_gr_length,
	--event_group, 
	ev_gr_id, year, dossierid, pageid, entryid
from tw1
order by dossierid, entryid, ev_gr_id ;



-- inspect
select substring(event_id FROM '-(.*)') event_own_id, *
from t_event_with_id
where ev_gr_length > 1
limit 50;


-- test join with event group

select ev.ev_gr_id, substring(event_id FROM '-(.*)')::integer event_own_id,
		ev.event_id, ev_gr_length, evg.ev_gr_class, ev.year, ev.event, evg.event_group, evg.entryid
from t_event_with_id ev, t_event_group_with_properties evg
where ev_gr_length > 1  
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
limit 50;





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
select unnest(xpath('//role', 
event)) as role, 
substring(event_id FROM '-(.*)')::int event_own_id, 
ev_gr_id, event_id, ev_gr_length,
event, year,dossierid,pageid,entryid
from t_event_with_id
where dossierid = 'HGB_1_002_026'
and ev_gr_length > 1
limit 100)
select
	ev_gr_id, substring(event_id FROM '-(.*)')::int event_own_id,
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
select unnest(xpath('//role', 
event)) as role, 
substring(event_id FROM '-(.*)')::int event_own_id, 
ev_gr_id, event_id, ev_gr_length,
event, year,dossierid,pageid,entryid
from t_event_with_id)
select
	ev_gr_id, substring(event_id FROM '-(.*)')::int event_own_id,
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


CREATE INDEX t_role_role_index ON t_role (role_role);
CREATE INDEX t_role_entryid_index ON t_role (entryid);
CREATE INDEX t_role_ev_gr_id_index ON t_role (ev_gr_id);



-- add foreign key
alter table t_role add column fk_t_event_group TEXT;
update t_role set fk_t_event_group = concat(entryid, '_', ev_gr_id);
CREATE INDEX idx_t_role_fk_t_event_group ON t_role (fk_t_event_group);
ALTER TABLE t_role ADD CONSTRAINT fk_t_event_group 
	FOREIGN KEY (fk_t_event_group) REFERENCES t_event_group_with_properties(pk_t_event_group);




-- inspect

select *
from t_role
--where ev_length > 3
order by entryid, ev_gr_id, event_id, role_ref
limit 200;




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





