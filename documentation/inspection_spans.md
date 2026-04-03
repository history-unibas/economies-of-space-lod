## Classes of root spans

### Documentation of the inspection

* [SQL scripts span inspection](../sql_queries_views/db_inspection_spans.sql)


N.B. According to the encoding manual (p. 2/4), spans annotated as 'reference' are those that "refer to the real-world entity". They thus have an attribute 'class' that (from the point of view of ontology engineering) provides the substance of the entity (OntoClean).

The corresponding main classes are listed in table 2.6, p.5.

The automatic annotation of the data (status 2 April 2026) shows some difference with regard to the manual:
* there are no mentions of instances of Facility
* there are a lot of mentions of instances of Location, probably referring to constructions 



### Distribution of 'reference' spans

* Total number of spans (2 april 2026): 2'569'255
* Total number of root spans : 694'961


|span_class|num_count|mapping|notes|
|----------|---------|-------|-----|
|per|337091|   (mention of a ) [crm:E5 Person](https://ontome.net/class/21/namespace/188)    |          |
|loc|269848|   (mention of a ) [sdh:C17 Construction](https://ontome.net/class/441)    |    Verify  if also natural features, like rivers, etc.    |
|org|55424|    (mention of a ) [crm:E74 Group](https://ontome.net/class/68)   |          |
|gpe|32008|     (mention of a ) [sdh:C13 Geographical Place](https://ontome.net/class/363)  |    From the analysis of entities, it appears that this could be intended in the sense of territories (not organisations) and thus instances of the class Geographical Place. But verify if this is the intended meaning and the encoding consistent (or a mix-up of territories and groups)     |
|unk|589|       |          |
||1|       |          |




``` SQL
select span_class, count(*) as num_count, '' AS notes
FROM t_spans ts 
where ts.span_element = 'reference'
group by span_class 
order by num_count desc;
```

#### Number of root and non root reference spans
 
* Root:343662
* Non-root : 351299

```SQL
with tw1 as (
select 
	case 
		when ts.fk_parent_span IS NULL
		then 'root'
		else 'non-root'
	end if_root
FROM t_spans ts 
where  ts.span_element = 'reference')
select if_root, count(*) as num
from tw1
group by if_root;
```





#### Distribution of all span classes that are not references

* These are 'entity description classes' according to the manual, p. 4/6-7 (table 2.7)
* We consider these classes as qualifications of references that have to analywd in their own encoding context
* (2 April 2026) The mapping can follow at a later stage 


|span_class|num_count|mapping|notes|
|----------|---------|-------|-----|
|nam|400874|     |   |
|date|282311|     |   |
|type|269336|     |   |
|per|157999|     |   |
|money|148489|     |   |
|loc|112943|     |   |
|due|81704|     |   |
|occ|80120|     |   |
|owner|58317|     |   |
|fam|38976|     |   |
|alias|26538|     |   |
|transaction|24295|     |   |
|time.rec|23827|     |   |
|cause|22168|     |   |
|dead|19897|     |   |
|title|18345|     |   |
|tax|15193|     |   |
|org-job|13457|     |   |
|org-aff|13457|     |   |
|comp|11754|     |   |
|seizure|9749|     |   |
|heir|8421|     |   |
|role|5527|     |   |
|interest-redeemable|4331|     |   |
|litigation|4204|     |   |
|redemption|2499|     |   |
|payment|1915|     |   |
|gen|1814|     |   |
|testament|1552|     |   |
|consent|1531|     |   |
|per-repr|1491|     |   |
|quant|1386|     |   |
|bequest|1259|     |   |
|org-repr|940|     |   |
|rel|690|     |   |
|transfer|688|     |   |
|property|674|     |   |
|subject|648|     |   |
||602|     |   |
|date.range|521|     |   |
|creditor|459|     |   |
|detail|456|     |   |
|date.rec|392|     |   |
|inheritance|353|     |   |
|same|256|     |   |
|hereditary|239|     |   |
|content|236|     |   |
|pledge|201|     |   |
|debtor|183|     |   |
|declaration|133|     |   |
|sanction|125|     |   |
|unk|114|     |   |
|part-of|99|     |   |
|construction|85|     |   |
|repr|80|     |   |
|date-interval|73|     |   |
|time|60|     |   |
|org-affil|46|     |   |
|consideration|46|     |   |
|other|37|     |   |
|grp|32|     |   |
|unclear|30|     |   |
|decision|29|     |   |
|part|24|     |   |
|capital|23|     |   |
|per-job|15|     |   |
|propery|11|     |   |
|unknown|7|     |   |
|buyer|3|     |   |
|origin|2|     |   |
|contra|1|     |   |
|org|1|     |   |
|fac|1|     |   |


```sql
select span_class, count(*) as num_count
FROM t_spans ts 
where ts.span_element != 'reference'
group by span_class 
order by num_count desc;
```

