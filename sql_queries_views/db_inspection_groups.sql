

SELECT *
FROM t_spans ts 
where ts.span_class = 'org'
LIMIT 10;

SELECT ts2.span_norm
FROM t_spans ts join t_spans ts2 on ts2.parent_span_id = ts.span_id 
where ts.span_class = 'org'
and ts2.span_class = 'nam'
offset 100
LIMIT 10;

SELECT ts2.span_norm, count(*) as num
FROM t_spans ts join t_spans ts2 on ts2.parent_span_id = ts.span_id 
where ts.span_class = 'org'
and ts2.span_class = 'nam'
group by ts2.span_norm
LIMIT 10;


SELECT span_norm, count(*) as num
FROM t_spans ts 
where ts.span_class = 'org'
group by span_norm
order by num desc;



SELECT ts2.span_norm
FROM t_spans ts join t_spans ts2 
	on ts2.fk_parent_span = ts.pk_t_spans
where ts.span_class = 'org'
and ts2.span_class = 'nam'
offset 100
LIMIT 10;


-- count occurrences of groups present in spans, in attribute 'norm'
SELECT ts2.span_norm, ts2.span_class, count(*) as num
FROM t_spans ts join t_spans ts2 
	on ts2.fk_parent_span = ts.pk_t_spans
where ts.span_class = 'org'
and ts2.span_class = 'nam'
--and ts2.span_norm ~* 'stif'
and ts2.span_norm ~* 'kloster'
group by ts2.span_norm, ts2.span_class
order by span_norm ;
order by num desc;


