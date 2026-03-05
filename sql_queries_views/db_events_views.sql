
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
--where pe.entryid = 'd7cb61aa-3215-49e3-b802-80a4540f35d6_20250307';
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

--drop view v_event_group_with_properties;

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


select count(*) as num
from t_event_group_with_properties;


-- inspect
select *
from t_event_group_with_properties
offset 500
limit 30;


/*
 * Explore data summarily
 * 
 */

select ev_gr_class, count(*) as number
from t_event_group_with_properties
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

drop view v_event_with_id;

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
limit 50)
select
	(xpath('role/@role', 
role))[1]::text as role_role,
	(xpath('role/@ref', 
role))[1]::text as role_ref,
	(xpath('role/@text', 
role))[1]::text as role_text,
	role, 
	event,
	ev_gr_length,
	ev_gr_id, substring(event_id FROM '-(.*)')::int event_own_id, 
	event_id, year, entryid
from tw1
order by entryid, ev_gr_id ;




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
	(xpath('role/@role', 
role))[1]::text as role_role,
	(xpath('role/@ref', 
role))[1]::text as role_ref,
	(xpath('role/@text', 
role))[1]::text as role_text,
	role, 
	event,
	ev_gr_length,
	ev_gr_id, substring(event_id FROM '-(.*)')::int event_own_id, 
	event_id, year, entryid
from tw1
order by entryid, ev_gr_id ;





-- inspect

select *
from t_role
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
 * 
 *  NOT NEEDED !!!
 * 
 * 
 * CREATE TABLE roles_with_events
 * 
 * When there are more data add a primary key and indexes on columns,
 * 
 * or test the performance of a temporary table
 * 
 */


-- create table
drop table t_roles_with_events ;
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

