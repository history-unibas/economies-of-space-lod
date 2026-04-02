## Classes of root spans

### Documentation of the inspection

* [SQL scripts span inspection](../sql_queries_views/db_inspection_spans.sql)

Total number of spans (2 april 2026): 2'569'255
Total number of root spans : 896'319

### Distribution of root span classes

```sql
select span_class, count(*) as num_count
FROM t_spans ts 
where ts.fk_parent_span = 0
group by span_class 
order by num_count desc;
```



| span_class          | num_count |
| --------------------- | ----------- |
| date                | 280066    |
| per                 | 205891    |
| money               | 120283    |
| loc                 | 114793    |
| due                 | 68200     |
| transaction         | 24013     |
| org                 | 20614     |
| time.rec            | 19614     |
| seizure             | 9742      |
| cause               | 9722      |
| litigation          | 4198      |
| gpe                 | 2817      |
| interest-redeemable | 2401      |
| redemption          | 2397      |
| payment             | 1895      |
| testament           | 1540      |
| consent             | 1428      |
| bequest             | 1258      |
| transfer            | 679       |
| property            | 659       |
| subject             | 644       |
| date.range          | 521       |
| unk                 | 520       |
| detail              | 425       |
| date.rec            | 390       |
| inheritance         | 335       |
| hereditary          | 238       |
| content             | 235       |
| pledge              | 200       |
| declaration         | 130       |
| sanction            | 125       |
| construction        | 85        |
| time                | 59        |
| consideration       | 44        |
| other               | 33        |
| unclear             | 30        |
| decision            | 29        |
| date-interval       | 26        |
| capital             | 23        |
| tax                 | 9         |
| buyer               | 3         |
| owner               | 3         |
| alias               | 1         |
| contra              | 1         |
