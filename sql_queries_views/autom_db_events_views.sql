

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
event_group)) as role,  ev.event,
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

drop view t_auto_role;
create table t_auto_role as
with tw1 as (
select ev.document_id, evg.entryid,
	unnest(xpath('//role', 
ev.event)) as role, 
	ev.ev_gr_id, ev.event_n, ev.event_id, evg.ev_gr_class, ev.year, ev.event
from t_auto_event_with_id ev, t_auto_event_group_with_properties evg
where ev_gr_length > 1
and ev.entryid = evg.entryid
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





-- test view

select *
from t_auto_role
where ev_gr_length > 3
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

