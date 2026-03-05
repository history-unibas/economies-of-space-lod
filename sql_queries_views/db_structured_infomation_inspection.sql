
-- number of spans: 2569255 on 5 March 2026
select count(*) as number
FROM t_spans ts ;


select *
FROM t_spans ts 
limit 10;


select *
FROM t_spans ts 
where ts.dossierid = 'HGB_1_002_046'
order by year, span_id;




-- with no parent, i.e. root span
select *
FROM t_spans ts 
where ts.parent_span_id is null
limit 10;


-- classes of root spans
select span_class, count(*) as num_count
FROM t_spans ts 
where ts.parent_span_id is null
group by span_class 
order by num_count desc;




-- event groups
select *
from t_event_group_with_properties tegwp 
limit 10;


-- number of class instances
select ev_gr_class, count(*) as num_count
from t_event_group_with_properties tegwp 
group by ev_gr_class 
order by num_count desc;


-- roles
select *
from t_auto_role tar 
limit 10;

select 
from t_auto_roles_with_events tarwe 
limit 10;

select tar.role_role, count(*) as num_count
from t_auto_role tar 
group by role_role 
order by num_count desc;

select tar.role_role, tar.ev_gr_class, count(*) as num_count
from t_auto_role tar 
group by role_role, ev_gr_class  
order by num_count desc;


with tw1 as (
select tar.role_role, tar.ev_gr_class, count(*) as num_count
from t_auto_role tar 
group by role_role, ev_gr_class  
), tw2 as (
select ev_gr_class, count(*) as num_count
from t_event_group_with_properties tegwp 
group by ev_gr_class 
)
select tw2.ev_gr_class, tw2.num_count num_class, 
tw1.role_role role, tw1.num_count num_role 
from tw1, tw2 
where tw1.ev_gr_class = tw2.ev_gr_class 
order by tw2.num_count, tw1.num_count ;


-- 
select owner1862, count(*) as num_count
from stabs_dossier 
group by owner1862 
order by num_count desc;
