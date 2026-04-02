

-- list examples of ownerships
select *
from t_event_group_with_properties eg 
where eg.ev_gr_class = 'ownership'
order by dossierid 
limit 20;

-- inspect counts of roles
select * 
from v_class_role_number
where ev_gr_class = 'ownership';


--inspect ownerships
select *
from t_event_group_with_properties eg 
where eg.ev_gr_class = 'ownership'
order by entryid 
limit 20;


-- inspect roles
select tr.entryid,  tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, eg.ev_gr_trigger_ref,
		eg.event_group,  tr."role"
from t_event_group_with_properties eg, 
	t_role tr 
where eg.ev_gr_class = 'ownership'
and tr.fk_t_event_group = eg.pk_t_event_group 
order by eg.entryid, eg.ev_gr_id, tr.role_ref 
limit 100;


-- inspect roles and spans
select tr.entryid, tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, 
		ts.span_text, ts.span_class, ts.span_norm ,
		eg.ev_gr_trigger_ref,
		eg.event_group, tr."role", ts.span 	
from t_event_group_with_properties eg, 
	t_role tr, t_spans ts 
where eg.ev_gr_class = 'ownership'
and tr.fk_t_event_group = eg.pk_t_event_group 
and ts.pk_t_spans = tr.fk_t_span 
order by eg.entryid, eg.ev_gr_id, tr.role_ref 
limit 100;


/*
 * We try here to connect the text with the buildings
 * and the archival documents
 * 
 * The Transkribus picture not available ?
 */


-- inspect roles and spans and addresses and archival refence
select tr.entryid, tr.role_role, tr.role_ref, tr.role_text,
		eg.ev_gr_id, eg.ev_gr_ref, 
		ts.span_text, -- ts.span_class, 
		pe.annotation_automated , tp.urlimage ,
		sd.housename, sd.title, sd.link,
		pd."locationshifted" , eg.dossierid, sd.descriptivenote ,
		ts.span_norm ,
		eg.ev_gr_trigger_ref,
		eg.event_group, tr."role", ts.span 
from t_event_group_with_properties eg, 
	t_role tr, t_spans ts,
	project_entry pe ,
	project_dossier pd, stabs_dossier sd ,
	transkribus_page tp 
where eg.ev_gr_class = 'ownership'
and tr.fk_t_event_group = eg.pk_t_event_group 
and ts.pk_t_spans = tr.fk_t_span 
and ts.span_class = 'loc'
and pe.entryid = eg.entryid 
and pd.dossierid = eg.dossierid 
and sd.dossierid = eg.dossierid 
and tp.entryid = pe.entryid 
order by eg.entryid, eg.ev_gr_id, tr.role_ref 
limit 100;



