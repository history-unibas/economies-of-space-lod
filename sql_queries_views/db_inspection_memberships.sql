

-- list examples of memberships
select *
from t_event_group_with_properties tegwp 
where tegwp.ev_gr_class = 'membership'
order by dossierid 
limit 20;

-- inspect counts of roles
select * 
from v_class_role_number
where ev_gr_class = 'membership';


--inspect memberships
select *
from t_event_group_with_properties tegwp 
where tegwp.ev_gr_class = 'membership'
order by entryid 
limit 20;


-- inspect roles
select tr.entryid,  tr.role_role, tr.role_ref, tr.role_text,
		tegwp.ev_gr_id, tegwp.ev_gr_ref, tegwp.ev_gr_trigger_ref,
		tegwp.event_group,  tr."role"
from t_event_group_with_properties tegwp, 
	t_role tr 
where tegwp.ev_gr_class = 'membership'
and tr.fk_t_event_group = tegwp.pk_t_event_group 
order by tegwp.entryid, tegwp.ev_gr_id, tr.role_ref 
limit 100;


-- inspect roles and spans
select tr.entryid, tr.role_role, tr.role_ref, tr.role_text,
		tegwp.ev_gr_id, tegwp.ev_gr_ref, 
		ts.span_text, ts.span_class, ts.span_norm ,
		tegwp.ev_gr_trigger_ref,
		tegwp.event_group, tr."role", ts.span 	
from t_event_group_with_properties tegwp, 
	t_role tr, t_spans ts 
where tegwp.ev_gr_class = 'membership'
and tr.fk_t_event_group = tegwp.pk_t_event_group 
and ts.pk_t_spans = tr.fk_t_span 
order by tegwp.entryid, tegwp.ev_gr_id, tr.role_ref 
limit 100;
