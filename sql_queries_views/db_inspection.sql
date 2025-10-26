

select count(*) as number
from project_entry pe ;

select *
from project_entry pe 
where pe.annotation is NULL
limit 10;

select count(*) as number
from project_entry pe 
where pe.annotation is not NULL;

select *
from project_entry pe 
where pe.annotation is not NULL
limit 10;


select *
from pg_available_extensions;



select *
from v_role
where ev_length > 3
order by entryid, ev_gr_id, event_id, role_ref
limit 200;