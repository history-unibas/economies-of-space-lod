

-- event groups XML

select unnest(xpath('//myns:eventGroup', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotation is not null;


/*
* Number of events per event group
*
* There are up to 12 events per event group, more often 2, 3 or 4
* This demands to have a dedicated table for events
*/

with tw1 as (
select unnest(xpath('//myns:eventGroup', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation is not null
--and pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('//myns:eventGroup/@event_id', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_id,
	array_length(xpath('//myns:eventGroup/myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])), 1) events_count,
	event_group, year, dossierid, pageid, entryid
from tw1
order by events_count DESC;




-- event group with properties

with tw1 as (
select unnest(xpath('//myns:eventGroup', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation is not null
and pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('//myns:eventGroup/@class', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_class,
	(xpath('//myns:eventGroup/@event_id', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_id,
	(xpath('//myns:eventGroup/@polarity', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_polarity,
	(xpath('//myns:eventGroup/@tense', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_tense,
	(xpath('//myns:eventGroup/@modality', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_modality,
	(xpath('//myns:eventGroup/myns:trigger/@text', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_trigger,
	(xpath('//myns:eventGroup/myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) event,
	event_group, year, dossierid, pageid, entryid
from tw1;




/*
 * CREATE VIEW for event group with properties
 */

--drop view v_event_group_with_properties;
create or replace view v_event_group_with_properties AS
with tw1 as (
select unnest(xpath('//myns:eventGroup', 
pe.annotation[1], (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation is not null
--and pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('//myns:eventGroup/@class', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_class,
	(xpath('//myns:eventGroup/@event_id', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_id,
	(xpath('//myns:eventGroup/@polarity', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_polarity,
	(xpath('//myns:eventGroup/@tense', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_tense,
	(xpath('//myns:eventGroup/@modality', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_modality,
	(xpath('//myns:eventGroup/myns:trigger/@text', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text ev_gr_trigger,
	event_group, year, dossierid, pageid, entryid
from tw1;


-- test view
select *
from v_event_group_with_properties
offset 500
limit 30;


/*
 * Explore data summarily
 * 
 */


select ev_gr_class, count(*) as number
from v_event_group_with_properties
group by ev_gr_class 
order by number desc;

select year, count(*) as number
from v_event_group_with_properties
group by year
order by year;






/*
 * Produce events table
 */

-- select events

select 
	unnest(xpath('//myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from v_event_group_with_properties
where entryid = '4a355df2-1398-4803-bc32-a8995b166927_20250307'
limit 20;


with tw1 as (
select 
	unnest(xpath('//myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from v_event_group_with_properties
where entryid = '4a355df2-1398-4803-bc32-a8995b166927_20250307'
limit 20)
select
	replace((xpath('//myns:event/@event_id', 
event, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text, '.', '-') as event_id,
	event, 
	array_length(xpath('//myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])),1) as ev_gr_length,
	--event_group, 
	ev_gr_id, year, dossierid, pageid, entryid
from tw1;





/*
 * CREATE VIEW for events with id
 */

--drop view v_event_with_id;
create or replace view v_event_with_id as
with tw1 as (
select 
	unnest(xpath('//myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from v_event_group_with_properties
--where entryid = '4a355df2-1398-4803-bc32-a8995b166927_20250307'
)
select
	replace((xpath('//myns:event/@event_id', 
event, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text, '.', '-') as event_id,
	event, 
	array_length(xpath('//myns:event', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])),1) as ev_gr_length,
	--event_group, 
	ev_gr_id, year, dossierid, pageid, entryid
from tw1;


-- test view

select *
from v_event_with_id
where ev_gr_length > 1
limit 50;




-- test join with event group

select ev.ev_gr_id, ev.event_id, evg.ev_gr_class, ev.year, ev.event, evg.event_group, evg.entryid
from v_event_with_id ev, v_event_group_with_properties evg
where ev_gr_length > 1
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
limit 50;





/*
 * Add roles table
 * 
 */
 

-- inspect
select 
	unnest(xpath('//myns:role', 
event_group, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as role, 
	ev.ev_gr_id, ev.event_id, evg.ev_gr_class, ev.year, ev.event, evg.entryid
from v_event_with_id ev, v_event_group_with_properties evg
where ev_gr_length > 1
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
limit 50;

-- roles with properties
with tw1 as (
select 
	unnest(xpath('//myns:role', 
event, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as role, 
	ev.ev_gr_id, ev.event_id, evg.ev_gr_class, ev.year, ev.event, evg.entryid
from v_event_with_id ev, v_event_group_with_properties evg
where ev_gr_length > 1
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
limit 50)
select
	(xpath('//myns:role/@role', 
role, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as role_role,
	(xpath('//myns:role/@ref', 
role, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as role_ref,
	(xpath('//myns:role/@text', 
role, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as role_text,
	role, 
	event,
	array_length(xpath('//myns:role', 
event, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])),1) as ev_gr_length,
	ev_gr_id, event_id, ev_gr_class, year, entryid
from tw1;








/*
 * CREATE VIEW for roles 
 */

--drop view v_role;
create or replace view v_role as
with tw1 as (
select 
	unnest(xpath('//myns:role', 
event, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']]))) as role, 
	ev.ev_gr_id, ev.event_id, evg.ev_gr_class, ev.year, ev.event, evg.entryid
from v_event_with_id ev, v_event_group_with_properties evg
where ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id)
select
	ev_gr_class, year, event_id,
	(xpath('//myns:role/@role', 
role, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as role_role,
	(xpath('//myns:role/@ref', 
role, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as role_ref,
	(xpath('//myns:role/@text', 
role, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])))[1]::text as role_text,
	array_length(xpath('//myns:role', 
event, (ARRAY[ARRAY['myns', 'https://dhbern.github.io/BeNASch/ns']])),1) as ev_length,
	role, 
	event,
	ev_gr_id,   entryid
from tw1;




-- test view

select *
from v_role
where ev_length > 3
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






/*
 * CREATE TABLE roles_with_events
 * 
 * When there are more data add a primary key and indexes on columns,
 * 
 * or test the performance of a temporary table
 * 
 */


-- create table
--drop table t_roles_with_events ;
create table t_roles_with_events as
select  row_number() OVER (ORDER BY 1)::INTEGER as pk_trwe,
ev.ev_gr_id, ev.ev_gr_length, ev.event_id, evg.dossierid, evg.ev_gr_class, ev.year, 
evg.event_group,
rol.role_role, rol.role_text, rol.role_ref,
evg.entryid
from v_event_with_id ev, v_event_group_with_properties evg, v_role as rol
where ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
and rol.entryid = evg.entryid
and rol.event_id = ev.event_id
and rol.ev_gr_id = ev.ev_gr_id;



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

