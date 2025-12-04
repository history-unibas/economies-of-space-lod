

-- event groups XML

select unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.dossierid =  'HGB_1_002_026' -- 'HGB_1_194_101' 
AND pe.annotation_automated is not null;



-- event group with document id
select (xpath('/document/@id', 
pe.annotation_automated))[1]::TEXT::INTEGER as document_id, 
unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
pe.annotation_automated,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.dossierid =  'HGB_1_002_026' -- 'HGB_1_194_101' 
AND pe.annotation_automated is not null;



/*
* Number of events per event group
*
* There are up to 12 events per event group, more often 2, 3 or 4
* This demands to have a dedicated table for events
*/

with tw1 as (
select (xpath('/document/@id', 
pe.annotation_automated))[1]::TEXT::INTEGER as document_id,
unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation_automated is not null 
and pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('//eventGroup/@event_id', 
event_group))[1]::text ev_gr_id,
	array_length(xpath('//eventGroup/event', 
event_group), 1) events_count,
	event_group, year, dossierid, document_id, pageid, entryid
from tw1
order by events_count DESC;




-- event group with properties

with tw1 as (
select (xpath('/document/@id', 
pe.annotation_automated))[1]::TEXT::INTEGER as document_id,
unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation_automated is not null
and pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('//eventGroup/@class', 
event_group))[1]::text ev_gr_class,
	(xpath('//eventGroup/@type', 
event_group))[1]::text ev_gr_type,
	(xpath('//eventGroup/@event_id', 
event_group))[1]::text ev_gr_id,
	(xpath('//eventGroup/@polarity', 
event_group))[1]::text ev_gr_polarity,
	(xpath('//eventGroup/@tense', 
event_group))[1]::text ev_gr_tense,
	(xpath('//eventGroup/@modality', 
event_group))[1]::text ev_gr_modality,
	(xpath('//eventGroup/trigger/@text', 
event_group))[1]::text ev_gr_trigger,
	array_length(xpath('//eventGroup/event', 
event_group),1) as event_length,
	(xpath('//eventGroup/event', 
event_group)) event,
	event_group, year, dossierid, document_id, pageid, entryid
from tw1;




/*
 * CREATE TABLE for event group with properties
 */

-- drop table t_auto_event_group_with_properties;
create table t_auto_event_group_with_properties AS
with tw1 as (
select (xpath('/document/@id', 
pe.annotation_automated))[1]::TEXT::INTEGER as document_id,
unnest(xpath('//eventGroup', 
pe.annotation_automated)) as event_group,
year, dossierid, pageid, entryid
from project_entry pe 
where pe.annotation_automated is not null
--and pe.dossierid = 'HGB_1_002_026'
)
select 
	(xpath('//eventGroup/@class', 
event_group))[1]::text ev_gr_class,
	(xpath('//eventGroup/@type', 
event_group))[1]::text ev_gr_type,
	(xpath('//eventGroup/@event_id', 
event_group))[1]::text ev_gr_id,
	(xpath('//eventGroup/@polarity', 
event_group))[1]::text ev_gr_polarity,
	(xpath('//eventGroup/@tense', 
event_group))[1]::text ev_gr_tense,
	(xpath('//eventGroup/@modality', 
event_group))[1]::text ev_gr_modality,
	(xpath('//eventGroup/trigger/@text', 
event_group))[1]::text ev_gr_trigger,
	array_length(xpath('//eventGroup/event', 
event_group),1) as event_length,
	(xpath('//eventGroup/event', 
event_group)) event,
	event_group, year, dossierid, document_id, pageid, entryid
from tw1;


CREATE INDEX ev_gr_class_index ON t_auto_event_group_with_properties (ev_gr_class);
CREATE INDEX ev_gr_type_index ON t_auto_event_group_with_properties (ev_gr_type);


-- test table
select *
from t_auto_event_group_with_properties
offset 500
limit 30;


/*
 * Explore data summarily
 * 
 */


select ev_gr_class, count(*) as number
from t_auto_event_group_with_properties
group by ev_gr_class 
order by number desc;


select ev_gr_type, count(*) as number
from t_auto_event_group_with_properties
group by ev_gr_type 
order by number desc;


select ev_gr_class, ev_gr_type, count(*) as number
from t_auto_event_group_with_properties
group by ev_gr_class, ev_gr_type
order by ev_gr_class, ev_gr_type ;






-- Distribution of documents by periods
WITH RECURSIVE periods AS (
    SELECT 1300 AS year_b, 1351 as year_e
    UNION ALL
    SELECT year_b + 50, year_e + 50
    FROM periods
    WHERE year_b < 1750
), years_with_periods AS(
select pe."year", CONCAT(ps.year_b, '_', ps.year_e ) as period
from t_auto_event_group_with_properties pe, periods ps
where pe."year" > ps.year_b and pe."year" < ps.year_e)
select period, count(*) as number
from years_with_periods 
group by "period" 
order by period;











/*
 * Produce events table
 */



-- inspect table
select *
from t_auto_event_group_with_properties
--offset 500
limit 30;


-- select events

select 
	unnest(xpath('//event', 
event_group)) as event, 
	event_group, ev_gr_id, year, dossierid, pageid, entryid
from t_auto_event_group_with_properties
where document_id = 30124
limit 20;


with tw1 as (
select 
	unnest(xpath('//event', 
event_group)) as event, 
	event_group, ev_gr_id, year, document_id, dossierid, pageid, entryid
from t_auto_event_group_with_properties
where document_id = 30124
limit 30)
select
	replace((xpath('//event/@event_id', 
event))[1]::text, '.', '-') as event_id, ev_gr_id,
	substring((xpath('//event/@event_id', 
event))[1]::text from position('.' in (xpath('//event/@event_id', 
event))[1]::text)+1) as event_n,
	event, 
	array_length(xpath('//event', 
event_group),1) as ev_gr_length,
	--event_group, 
	 year, dossierid, document_id, pageid, entryid
from tw1;




/*
 * CREATE TABLE for events with id
 * 
 */

--drop table t_auto_event_with_id;
create table t_auto_event_with_id as
with tw1 as (
select 
	unnest(xpath('//event', 
event_group)) as event, 
	event_group, ev_gr_id, year, document_id, dossierid, pageid, entryid
from t_auto_event_group_with_properties)
select
	replace((xpath('//event/@event_id', 
event))[1]::text, '.', '-') as event_id, ev_gr_id,
	substring((xpath('//event/@event_id', 
event))[1]::text from position('.' in (xpath('//event/@event_id', 
event))[1]::text)+1) as event_n,
	event, 
	array_length(xpath('//event', 
event_group),1) as ev_gr_length,
	--event_group, 
	 year, dossierid, document_id, pageid, entryid
from tw1;




-- test table

select *
from t_auto_event_with_id
where ev_gr_length > 1
limit 50;




-- test join with event group

select ev.ev_gr_id, ev.event_id, evg.ev_gr_class, ev.year, ev.event, evg.event_group, 
ev.document_id, evg.entryid
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg
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
	unnest(xpath('//role', 
event_group)) as role,  ev.event, ev.document_id,
	ev.ev_gr_id, ev.event_id, evg.ev_gr_class, ev.year, evg.entryid
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg
where ev_gr_length > 1
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
limit 50;



-- roles with properties
with tw1 as (
select ev.document_id, evg.entryid,
	unnest(xpath('//role', 
ev.event)) as role, 
	ev.ev_gr_id, ev.event_n, ev.event_id, evg.ev_gr_class, ev.year, ev.event
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg
where ev_gr_length > 1
and ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id
limit 50)
select  document_id,
	(xpath('//role/@role', 
role))[1]::text as role_role,
	(xpath('//role/@ref', 
role))[1]::text as role_ref,
	(xpath('//role/@text', 
role))[1]::text as role_text,
	role, 
	event,
	array_length(xpath('//role', 
event),1) as ev_gr_length,
	ev_gr_id, event_n, event_id, ev_gr_class, year, entryid
from tw1;








/*
 * CREATE TABLE for roles 
 */

drop table t_auto_role;
create table t_auto_role as
with tw1 as (
select ev.document_id, evg.entryid,
	unnest(xpath('//role', 
ev.event)) as role, 
	ev.ev_gr_id, ev.event_n, ev.event_id, evg.ev_gr_class, ev.year, ev.event
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg
where ev.entryid = evg.entryid
and ev.ev_gr_id = evg.ev_gr_id)
select  document_id,
	(xpath('//role/@role', 
role))[1]::text as role_role,
	(xpath('//role/@ref', 
role))[1]::text as role_ref,
	(xpath('//role/@text', 
role))[1]::text as role_text,
	role, 
	event,
	array_length(xpath('//role', 
event),1) as ev_gr_length,
	ev_gr_id, event_n, event_id, ev_gr_class, year, entryid
from tw1;





-- inspect table

select *
from t_auto_role
where ev_gr_length > 3
order by entryid, ev_gr_id, event_id, role_ref
limit 200;




-- test join with event group, event and role

select *
from t_auto_event_with_id
limit 20;

select *
from t_auto_event_group_with_properties
order by dossierid, document_id, ev_gr_id
limit 30;



select evg.dossierid, ev.event_id, ev.ev_gr_id, ev.ev_gr_length,   evg.ev_gr_class, ev.year, 
rol.role_role, rol.role_text, rol.ev_gr_length,
evg.event_group, evg.entryid
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg, t_auto_role as rol
where ev.ev_gr_length = 2
and ev.dossierid = evg.dossierid 
and ev.document_id = evg.document_id
and ev.ev_gr_id = evg.ev_gr_id
and rol.document_id = evg.document_id
and rol.event_id = ev.event_id
and rol.ev_gr_id = ev.ev_gr_id
limit 50;


-- VERIFY
--and rol.ev_gr_length > 3
--and rol.ev_gr_length < 8



/*
 * CREATE TABLE roles_with_events
 * 
 * When there are more data add a primary key and indexes on columns,
 * 
 * or test the performance of a temporary table
 * 
 */


select count(*) as n
from t_auto_event_with_id;

select count(*) as n
from t_auto_event_group_with_properties evg;

select count(*) as n
from t_auto_role tr;


-- create table
drop table t_auto_roles_with_events ;
create table t_auto_roles_with_events as
select  row_number() OVER (ORDER BY 1)::INTEGER as pk_trwe,
evg.dossierid, evg.document_id, ev.ev_gr_id, ev.ev_gr_length, 
ev.event_id, evg.ev_gr_class, ev.year, evg. ev.event,rol.role,
rol.role_role, rol.role_text, rol.role_ref,
evg.entryid
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg, t_auto_role as rol
where ev.dossierid = evg.dossierid 
and ev.document_id = evg.document_id
and ev.ev_gr_id = evg.ev_gr_id
and rol.document_id = evg.document_id
and rol.event_id = ev.event_id
and rol.ev_gr_id = ev.ev_gr_id;



-- test t_roles_with_events

select pk_trwe, dossierid, document_id, ev_gr_id,  role_ref, 
	"year", ev_gr_class, role_role, role_text, 
	ev_gr_length, event_id, role, event, entryid
from t_auto_roles_with_events
where ev_gr_length > 3
order by dossierid, document_id, ev_gr_id, event_id, role_ref
limit 200;


/*
 * Count event groups, events and roles
 */


-- count event-type classes
select ev_gr_class, ev_gr_type, count(*) as number
from t_auto_event_group_with_properties
group by ev_gr_class, ev_gr_type
order by ev_gr_class, ev_gr_type ;


-- event groups with more then one event
select *
from t_auto_event_group_with_properties
where event_length > 1
order by dossierid, document_id, ev_gr_id::integer
limit 20;


-- count event types AT GROUPS LEVEL
select ev_gr_class, count(*) as number
from t_auto_event_group_with_properties
group by ev_gr_class
order by number desc;



-- count event types AT SINGLE EVENT LEVEL
select ev_gr_class, sum(event_length) as number
from t_auto_event_group_with_properties
group by ev_gr_class
order by number desc;


-- inspect roles

select *
from t_auto_roles_with_events
limit 30;


-- count roles
select role_role, count(*) as number
from t_auto_roles_with_events
group by role_role
order by number desc;


select ev_gr_class, role_role, count(*) as number
from t_auto_roles_with_events
group by ev_gr_class,role_role
order by number desc;


select ev_gr_class, count(*) as number
from t_auto_roles_with_events
group by ev_gr_class
order by number desc;

select ev_gr_class, count(*) as class_number
from t_auto_roles_with_events
group by ev_gr_class
order by class_number desc;


select ev_gr_class, count(*) as class_number
from t_auto_event_with_id taewi 
group by ev_gr_class
order by class_number desc;

select *
from t_auto_event_with_id taewi 
order by dossierid, document_id, ev_gr_id::integer
limit 20;


-- count sigle events types and role numbers per type
with tw1 as (
select ev_gr_class, role_role, count(*) as role_number
from t_auto_roles_with_events
group by ev_gr_class,role_role),
tw2 as (
-- count event types AT SINGLE EVENT LEVEL
select ev_gr_class, sum(event_length) as class_number
from t_auto_event_group_with_properties
group by ev_gr_class)
select tw2.ev_gr_class, tw2.class_number, 
tw1.role_role, tw1.role_number
from tw2, tw1
where tw1.ev_gr_class = tw2.ev_gr_class
order by class_number desc, role_number desc;

