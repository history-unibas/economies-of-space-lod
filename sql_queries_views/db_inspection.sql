

select count(*) as number
from project_entry pe 
where pe.annotation is not null
;

select count(*) as number
from project_entry pe 
where pe.annotation is null
;


-- inspect structure of table
select *
from project_entry pe 
where pe.annotation is not null
order by dossierid, pageid 
limit 30;





select *
from v_role
where ev_length > 3
order by entryid, ev_gr_id, event_id, role_ref
limit 200;