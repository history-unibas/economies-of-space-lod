


## Spans

* Spans are collections of one or more tokens with some meaning and refer to named entities or values
  * spans also have some grammatical or NLP attributes like 'reference', 'head', 'apposition', etc.
  * they refer to objects of type 'person', 'organisation', etc.
* They have been extracted to the table *t_spans*
* We map them to instances of the class *sdh-info:C16 Chunk*
* The URI of spans/chnks is provided by a concatenation of the 'entityid' table column and the span 'id' attribute in the form: *0eb11e76-b4de-4462-b15d-5a443d5b4523_20250307_span0*
  * this columns 'span_uri' is the primary key of the table


### Mapping of attributes

* @text is mapped to the primitive value  crm:E62 String associated with the property crm:P190 has symbolic content

