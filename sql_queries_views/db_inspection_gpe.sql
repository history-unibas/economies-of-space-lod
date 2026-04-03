/*
* Inspection of geo-political entities 
*/

select *
FROM t_spans ts 
where  ts.span_element = 'reference'
and ts.span_class ='gpe'
offset 100
limit 100;


-- get the child element 'head' with the name ('nam')
select ts1.span_text name, ts.span, ts1.*, ts.*
FROM t_spans ts 
   left join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
   			and ts1.span_element = 'head'
where  ts.span_element = 'reference'
and ts.span_class ='gpe'
offset 100
limit 100;




-- count occurrences
select ts1.span_text name, count(*) as num
FROM t_spans ts 
   left join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
   			and ts1.span_element = 'head'
where  ts.span_element = 'reference'
and ts.span_class ='gpe'
group by ts1.span_text
order by num DESC;






-- count occurrences with / without Basel - Stat
select ts1.span_text name, count(*) as num
FROM t_spans ts 
   left join t_spans ts1 on ts1.fk_parent_span = ts.pk_t_spans 
   			and ts1.span_element = 'head'
where  ts.span_element = 'reference'
and ts.span_class ='gpe'
--and ts1.span_text ~* 'basel|stat'
and ts1.span_text !~* 'basel|stat'
group by ts1.span_text
order by num DESC;



