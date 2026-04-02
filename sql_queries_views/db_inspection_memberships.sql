

-- list examples of memberships
select *
from t_event_group_with_properties eg 
where eg.ev_gr_class = 'membership'
order by dossierid 
limit 20;

-- inspect counts of roles
select * 
from v_class_role_number
where ev_gr_class = 'membership';


--inspect memberships
select *
from t_event_group_with_properties eg 
where eg.ev_gr_class = 'membership'
order by entryid 
limit 20;


-- inspect roles
select tr.entryid,  tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, eg.ev_gr_trigger_ref,
		eg.event_group,  tr."role"
from t_event_group_with_properties eg, 
	t_role tr 
where eg.ev_gr_class = 'membership'
and tr.fk_t_event_group = eg.pk_t_event_group 
order by eg.entryid, eg.ev_gr_id, tr.role_ref 
limit 100;


-- inspect roles and spans
select tr.entryid, tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, 
		ts.span_text, ts.span_class, ts.span_norm ,
		ts1.span_text, ts1.span_class, ts1.span_norm ,
		eg.ev_gr_trigger_ref,
		eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg, 
	t_role tr, t_spans ts , t_spans ts1
where eg.ev_gr_class = 'membership'
and tr.fk_t_event_group = eg.pk_t_event_group 
and ts.pk_t_spans = tr.fk_t_span 
and ts1.fk_parent_span = ts.pk_t_spans 
and tr.role_role = 'organization'
order by eg.entryid, eg.ev_gr_id, tr.role_ref 
limit 100;




-- inspect normierte organisationen
with tw1 as (
select tr.entryid, tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, 
		ts.span_text, ts.span_class, -- ts.span_norm ,
		ts1.span_text, ts1.span_class, ts1.span_norm ,
		eg.ev_gr_trigger_ref,
		eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg, 
	t_role tr, t_spans ts , t_spans ts1
where eg.ev_gr_class = 'membership'
and tr.fk_t_event_group = eg.pk_t_event_group 
and ts.pk_t_spans = tr.fk_t_span 
and ts1.fk_parent_span = ts.pk_t_spans 
and tr.role_role = 'organization')
select span_norm, count(*) as num
from tw1
group by span_norm
order by num desc;
