

/* 
* Inspection of spans
* and their semantic content
*/


-- number of spans: 2569255 on 5 March 2026
select count(*) as number
FROM t_spans ts ;


select *
FROM t_spans ts 
limit 10;


select *
FROM t_spans ts 
where ts.dossierid = 'HGB_1_002_046'
order by year, span_id;

select *
FROM t_spans ts 
where ts.entryid = 'e6f83ab7-8c6b-4c4a-8fe9-f52439910278_20250307'
order by span_id;



/*
 * Root spans
 * 
 * Beware: the position in the XML hierarchy is not 
 * or less relevant thant the attribute element='reference'
 * for identifying top-level spans
 */


-- with no parent, i.e. root span
select *
FROM t_spans ts 
where ts.fk_parent_span = 0
limit 10;


-- number of root span : 896319
select count(*)
FROM t_spans ts 
where ts.fk_parent_span = 0;




/*
 * Spans with element="reference"
 * 
 * These are the spans referring to 'ENDURANTS'
 * 
 */

-- spans with element='reference'
select *
FROM t_spans ts 
where ts.span_element = 'reference'
limit 10;

-- number of reference spans: 694961
select count(*)
FROM t_spans ts 
where  ts.span_element = 'reference';



-- number of root and non root reference spans:
-- no-root	351299
-- root	343662
with tw1 as (
select 
	case 
		when ts.fk_parent_span IS NULL
		then 'root'
		else 'not_root'
	end if_root
FROM t_spans ts 
where  ts.span_element = 'reference')
select if_root, count(*) as num
from tw1
group by if_root;

-- number of root span AND reference spans : 343662
select count(*)
FROM t_spans ts 
where ts.fk_parent_span = 0 
and ts.span_element = 'reference';




/*
 * Semantic analysis
 * 
 */


-- CLASSES of REFERENCE spans
select span_class, count(*) as num_count, 
'       ' as mapping, '          ' as notes
FROM t_spans ts 
where ts.span_element = 'reference'
group by span_class 
order by num_count desc;




-- classes of root spans: not useful !
select span_class, count(*) as num_count
FROM t_spans ts 
where ts.fk_parent_span is NULL
group by span_class 
order by num_count desc;





/*
 * Semantic analysis of non-reference spans
 * 
 * These are 'entity description classes' according to the manual, p. 6-7
 * table 2.7
 * 
 */

-- classes of non-reference spans
select span_class, count(*) as num_count,
'     ' as mapping, '   ' as notes
FROM t_spans ts 
where ts.span_element != 'reference'
group by span_class 
order by num_count desc;

