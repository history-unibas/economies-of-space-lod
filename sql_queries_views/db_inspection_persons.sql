select *
from t_spans ts 
limit 50;



select ts_per.span_text, ts_name.span_text, ts_per.span 
FROM t_spans ts_per, t_spans ts_name
where ts_per.entryid = ts_name.entryid
and ts_per.parent_span_id is not null 
--and ts_per.span_class = 'per'
and ts_per.span_class = 'org'
and ts_name.parent_span_id is not null 
and ts_name.span_class = 'nam'
--and ts_name.element = 'head'
and ts_per.span_id = ts_name.parent_span_id 
limit 100;



select ts.span_class, count(*) as num_count
from t_spans ts 
group by ts.span_class 
order by num_count desc;



select tr.role_role, count(*) as num_count
from t_role tr
group by tr.role_role 
order by num_count desc;



select *
FROM t_spans ts_name
where ts_name.parent_span_id is not null 
and ts_name.span_class = 'nam'
limit 100;



select span_text, count(*) as num_count, string_agg(ts_name."year"::text, ',' order by ts_name."year")
FROM t_spans ts_name
where ts_name.parent_span_id is not null 
and ts_name.span_class = 'nam'
and ts_name.span_element = 'head'
group by span_text
having count(*) between 3 and 10
order by num_count desc;


select ts_name.span_text, count(*) as num_count, string_agg(ts_name."year"::text, ',' order by ts_name."year")
FROM t_spans ts_per, t_spans ts_name
where ts_per.entryid = ts_name.entryid
and ts_per.parent_span_id is not null 
--and ts_per.span_class = 'per'
and ts_per.span_class = 'org'
and ts_name.parent_span_id is not null 
and ts_name.span_class = 'nam'
--and ts_name.element = 'head'
and ts_per.span_id = ts_name.parent_span_id 
group by ts_name.span_text;
--having count(*) between 3 and 10
order by num_count desc;



select *
from t_spans ts 
where ts.span_text = 'Sebastian Spörlin';

select pe.annotation_automated, pe.year
from t_spans ts, project_entry pe
where ts.span_text = 'Sebastian Spörlin'
and ts.entryid = pe.entryid 
order by pe.year;




-- 
select owner1862, count(*) as num_count
from stabs_dossier 
group by owner1862 
order by num_count desc;