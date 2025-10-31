/*
 * link: https://database.factgrid.de/wiki/Item:Q665096
 */





select ts.span_text, count(*) number
FROM t_spans ts 
where ts.span_class = 'occ'
and ts.span_element = 'head'
group by ts.span_text 
order by number desc;