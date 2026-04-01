

/* 
* Inspection of spans
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




-- with no parent, i.e. root span
select *
FROM t_spans ts 
where ts.parent_span_id is null
limit 10;


-- number of root span
select count(*)
FROM t_spans ts 
where ts.parent_span_id is null
limit 10;


-- classes of root spans
select span_class, count(*) as num_count
FROM t_spans ts 
where ts.parent_span_id is null
group by span_class 
order by num_count desc;






