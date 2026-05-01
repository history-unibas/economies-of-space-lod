
/*
 * Inspection of events of class- property purchase
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
