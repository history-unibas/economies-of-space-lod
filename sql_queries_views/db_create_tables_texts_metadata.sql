/*
 * FB,18 June 2026
 * 
 */

select *
from project_entry pe
limit 10;


-- inspect project entry
select *
from project_entry pe
where pe.annotationautomated is not null
limit 10;



CREATE VIEW v_project_entry AS
select *
from project_entry pe
where pe.annotationautomated is not null;

select *
from v_project_entry
limit 10;





/*
 * About the different kinds of spans: reference, head, etc.
 * cf. Annotation manual 2.2.1 : Reference
 * 
 */


ALTER TABLE public.project_entry OWNER to hgb_editor;


-- first level span
select unnest(xpath('//metadata/@text', 
pe.annotationautomated))::text as entry_text,
--unnest(xpath('//metadata', pe.annotationautomated))as metadata,
year, dossierid, 
--pageid, 
entryid
from project_entry pe 
where pe.dossierid = 'HGB_1_002_026' 
AND pe.annotationautomated is not null
order by year;


alter table project_entry add column entry_text text;

begin;
with tw1 as (select unnest(xpath('//metadata/@text', 
pe.annotationautomated))::text as entry_text,
entryid
from project_entry pe 
where pe.annotationautomated is not null
)
update project_entry pe set entry_text = tw1.entry_text
from tw1
where pe.annotationautomated is not null
and tw1.entryid=pe.entryid;

select entry_text, pe.annotationautomated 
from project_entry pe 
where pe.annotationautomated is not null
limit 10;

rollback;
commit;
