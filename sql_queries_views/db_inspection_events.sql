/*
 * Inspection of events, general approach
 */


-- number of event groups
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
 * Explore years
 */

-- year
select year, count(*) as number
from t_event_group_with_properties
group by year
order by year;



-- Distribution of event-groups by periods
WITH RECURSIVE periods AS (
    SELECT 1300 AS year_b, 1351 as year_e
    UNION ALL
    SELECT year_b + 50, year_e + 50
    FROM periods
    WHERE year_b < 1750
), years_with_periods AS(
select pe."year", CONCAT(ps.year_b, '_', ps.year_e ) as period
from t_event_group_with_properties pe, periods ps
where pe."year" > ps.year_b and pe."year" < ps.year_e)
select period, count(*) as number
from years_with_periods 
group by "period" 
order by period;




-- number of class instances
select ev_gr_class, count(*) as num_count
from t_event_group_with_properties tegwp 
group by ev_gr_class 
order by num_count desc;


-- roles
select *
from t_role tar 
limit 10;

-- event groups
select * 
from t_event_group_with_properties eg; 


-- number of roles
select tar.role_role, count(*) as num_count
from t_role tar 
group by role_role 
order by num_count desc;



-- roles and event classes
--explain
select r.ev_gr_id, r.role_role, eg.ev_gr_class 
from t_role r, t_event_group_with_properties eg 
where eg.ev_gr_id = r.ev_gr_id 
and eg.entryid = r.entryid 
limit 100;


-- roles and event classes
create or replace view v_class_role_number as
with tw1 as (
select r.role_role, eg.ev_gr_class as class
from t_role r, t_event_group_with_properties eg 
where eg.ev_gr_id = r.ev_gr_id 
and eg.entryid = r.entryid 
), tw2 as (
select role_role, class, count(*) as role_class_num
from tw1
group by role_role, class
), tw3 as (
select ev_gr_class, count(*) as num_count
from t_event_group_with_properties tegwp 
group by ev_gr_class 
)
select tw3.ev_gr_class, tw3.num_count, tw2.role_role, tw2.role_class_num  
from tw2, tw3 
where tw2."class" = tw3.ev_gr_class 
order by tw3.num_count desc, tw2.role_class_num desc;



select * 
from v_class_role_number;
where ev_gr_class = 'membership';
