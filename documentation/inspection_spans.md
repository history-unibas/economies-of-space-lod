


## Classes of root spans

### Query

```
select span_class, count(*) as num_count
FROM t_spans ts 
where ts.parent_span_id is null
group by span_class 
order by num_count desc;
```


### Result

|span_class|num_count|
|----------|---------|
|date|280066|
|per|205891|
|money|120283|
|loc|114793|
|due|68200|
|transaction|24013|
|org|20614|
|time.rec|19614|
|seizure|9742|
|cause|9722|
|litigation|4198|
|gpe|2817|
|interest-redeemable|2401|
|redemption|2397|
|payment|1895|
|testament|1540|
|consent|1428|
|bequest|1258|
|transfer|679|
|property|659|
|subject|644|
|date.range|521|
|unk|491|
|detail|425|
|date.rec|390|
|inheritance|335|
|hereditary|238|
|content|235|
|pledge|200|
|declaration|130|
|sanction|125|
|construction|85|
|time|59|
|consideration|44|
|other|33|
|unclear|30|
|decision|29|
|date-interval|26|
|capital|23|
|tax|9|
|buyer|3|
|owner|3|
|alias|1|
|contra|1|


