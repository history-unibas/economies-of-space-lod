

select *
FROM t_spans ts 
limit 10;


select count(*) as number
FROM t_spans ts ;


select *
FROM t_spans ts 
where ts.dossierid = 'HGB_1_002_046'
order by year, span_id;



select *
FROM t_roles_with_events trwe 
limit 10;


select count(*) as number
FROM t_roles_with_events ;

--select *
select year, event_id, ev_gr_class, role_role as role, role_text, role_ref  
from t_roles_with_events
where dossierid = 'HGB_1_002_046'
order by year, event_id ;






-- connection with spans

select tre.year, tre.event_id, tre.ev_gr_class, tre.role_role as role, tre.role_text, tre.role_ref,
		ts.span_class, tre.event_id,
		ts1.span_text as child_text, ts1.span_class child_class, ts1.parent_span_id 
from t_roles_with_events tre, 
	t_spans ts,
	t_spans ts1
where tre.dossierid = 'HGB_1_002_046'
and tre.role_ref = ts.span_id 
and ts.dossierid = 'HGB_1_002_046'
and ts1.parent_span_id = ts.span_id 
and ts1.dossierid = 'HGB_1_002_046'
order by tre.year, tre.event_id, tre.role_ref  ;







