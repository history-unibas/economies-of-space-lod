
## Chunks

* Prepare the tables using the SQL script [db_create_tables_spans.sql](../sql_queries_views/db_create_tables_spans.sql)
* Prepare the R2RML mapping using the [mapping_spans.ttl](mapping_spans.ttl) document
* Upload or replace the script in the local Graph-DB instance
* Test the result with some SPARQL queries

&nbsp;

* Export the data to a chunks.nq file
* Compress it to the .gz format
* Upload it into the online triplestore, into the graph with the URL: [https://eos.lod4hss.org/graphs/data](https://eos.lod4hss.org/graphs/data)