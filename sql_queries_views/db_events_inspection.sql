create view v_dossier_id_page_id AS
select pe.dossierid, unnest(pe.pageid) as pageid 
from project_entry pe ;

select *
from v_dossier_id_page_id
limit 10;



SELECT *
FROM t_roles_with_events trwe 
where trwe.dossierid = 'HGB_1_002_046';


with tw1 as (
select t1.year, t1.event_group,t1.dossierid , unnest(t1.pageid) as pageid
from v_event_group_with_properties t1 
)
select tw1.*, tp.*
from tw1, transkribus_page tp 
where tw1.pageid = tp.pageid 
and dossierid = 'HGB_1_002_046';
;
