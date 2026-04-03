

/*
 * 3 April 2026
 * 
 * The URL of the transkribus document changed.
 * 
 * A CSV with the new URLs was transformed in a table:
 * transkribus_page_url_update
 * 
 * Once the update was done, as documented below, the table was deleted.
 * 
 */

SELECT count(*)
from transkribus_page_url_update;

SELECT *
from transkribus_page_url_update
limit 3;

SELECT count(*)
from transkribus_page tp ;

update transkribus_page t set urlimage = t1.urlimage  
from transkribus_page_url_update t1
where t1.pageid = t.pageid;