# Database structure and content

Back to [home](../README.md)


[Original description and documentation](https://github.com/history-unibas/economies-of-space-database) (GitHub)

Address book 1862: information on the cover, Kadasterplan

Two phases of production of cards



"Die Regesten zu den Liegenschaften der Basler Altstadt wurde in zwei langjährigen Bearbeitungsperioden angelegt: In einer ersten Bearbeitungsphase **zwischen 1895 und 1935** wurden als Quellen die Fertigungsbücher (Handänderungen), die Judicalienbücher (Auskündigungen von Liegenschaftskäufen), die Fröhnungsbücher (Versteigerungen infolge von Pfandbetreibung und Konkurs), die Protokolle des Fünfergerichts (Baugericht), die Hausurkunden, die Zinscorpora im Klosterarchiv, das Notariatsarchiv sowie die Staatsurkunden ausgewertet. In einer zweiten Bearbeitungsphase wurden zwischen 1968 und 1977 zusätzlich die Steuerbücher des Reichspfennigs von 1497 sowie die Brandlagerbücher (Brandversicherungen) ab 1807 ausgezogen.

Die Sammlung umfasst rund 220‘000 Regesten, die bis 2019 im Lesesaal des Staatsarchivs frei benutzt werden konnten. Diese Regesten wurden von Januar 2019 bis Juni 2020 neu erfasst und für die künftige orts- und zeitunabhängige Benutzung digitalisiert; die Originale wurden aufgrund ihres teilweise schlechten Erhaltungszustand zu deren Schonung der Benutzung entzogen, neu verpackt und in einem Archivmagazin abgelegt."



Source: [https://dls.staatsarchiv.bs.ch/records/1027330](https://dls.staatsarchiv.bs.ch/records/1027330 "https://dls.staatsarchiv.bs.ch/records/1027330")



### Staatsarchiv Basel-Stadt

* Linked Data Portal Basel-Stadt
  * https://ld.bs.ch/
  * [SPARQL Endpoint](https://ld.bs.ch/sparql/)
* [Digitaler Lesesaal](https://dls.staatsarchiv.bs.ch/)



## Cards examples

See here some [examples of transcriptions](cards_examples.md)

## Database tables

### stabs_serie

Content:

* Intentional (or physical?) collection of folders (aligned with physical set)
* It is dedicated to a street, a square, etc.
* It has a record in the digital archive and on website

Class:

* Intentional or physical collection

Properties (values):

* Use the *serieid* column as URI ?
* title as standard label
* owl:sameAs to *link*
  * e.g. [Engelgasse](https://ld.bs.ch/ais/Record/1465000)
  * Links appear to be URIs, cf. this [SPARQL query](https://ld.bs.ch/sparql/#query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0ASELECT+*+WHERE+%7B%0A++%3Chttps%3A%2F%2Fld.bs.ch%2Fais%2FRecord%2F1465000%3E+%3Fpred+%3Fobj+.%0A%7D+%0ALIMIT+20&contentTypeConstruct=text%2Fturtle&contentTypeSelect=application%2Fsparql-results%2Bjson&endpoint=https%3A%2F%2Fld.bs.ch%2Fquery&requestMethod=POST&tabTitle=Query&headers=%7B%7D&outputFormat=tablehttps:/)

Relations (rdf properties):

* No outgoing
* Incoming defined in *stabs_dossier* table



### stabs_dossier

Cards/texts in a StABS_Dossier ***are about a building, address or further information of a street***. The elements are at the "Dossier" level at the State Archives. Dossiers that do not have subordinate units at the State Archives are not represented in this table.

A physical collection comprising cards ?

Class:

* physical collection


Properties:

* URI: dossierid as the primary key in the connection to the other tables
  * Example: HGB_1_053_008
* serieid: reference to the StABS series
* title: generally the Address or similar
  * Example: Barfüsserplatz: Übersicht, Barfüsserplatz Theil von 5, Ecke und neben 6
* link: URL to StABS record
  * Example: HGB_1_024_001 -> [https://ld.bs.ch/ais/Record/1462466](https://ld.bs.ch/ais/Record/1462466https:/)
  * rdf:type [https://www.ica.org/standards/RiC/ontology#RecordSet](https://www.ica.org/standards/RiC/ontology#RecordSet)
* owner1862: von Hand hinzugefügt aus dem Digitalen Lesesaal (Jonas ???)


### Important note

Per each dossier there's a thing, a 'construction/address (cadaster plan)' that is intended

Name of this thing should be present in the annotated XML text

The URI will have to be produced *ex nihilo*



### projet_dossier

Provides *geocoordinates*

* *dossierid* is StABS *dossierid*
* locationorigin:
  * example: Grundbuch- und Vermessungsamt Basel-Stadt, manell geprüft
* location (POINT) (vom StABS)
* locationshifted (POINT)
* locationshiftedorigin
* clustering ?!? (irrelevant für die Publikation ?? Jonas fragen)

Alle Informationen, die alle Dokumente vom dossier sich teilen

Alle Dossiers beinhalten mehrer Karten (einige wurden ausgefiltert)


### Important note

one to one relation to the Stabs dossier, origine of columns is different


### project_relationship


Important information to be taken over (about the same object, of merged objects, identification of buyers, sellers, etc.)


Associates source with target dossier:

sourceDossier -- descendant --> targetDossier


Kind of relationship: separate addresses, unify addresses (houses as different addresses at different times, splitted, then merged or resplitted)

'dossier' change over time documented here



### project_entry

"Elements of the Project_Entry table represent an entry recorded in the HGB. __*Several entries can be documented on one register card of the HGB or one entry can extend over several pages/register cards*__ [???]. A page in the HGB is represented by an element in the table Transkribus_Page. If there are ***several entries*** on a register card, these entries are not currently represented by several elements in this table."

Rein semantisches Konzept ?!?

IN reality this is the place where you find the encoded XML document, therefore map to Linguistic object ? ou Information object

* document id="83080" attribute will be cleared and disappear in next update
* relevant ID or pk is the 'entryid'
  * e.g.: 4fe69dcc-ac68-4e5d-9bb5-13a579e5ac39_20250307



### transkribus_page

* in den meisten Fällen ein Eintrag (project-entry) pro Registerkarte
* eintrag : einleitungs datum, paragraph, credit, footer (types von **transkribus region**)
* manchmal ein Eintrag über mehrere seiten = bilder (transkribus pages)
* sehr selten : eine seite / kard : mehrer einträge (nicht berücksichtigt, nicht in der Datenbankstruktur)

Notes concernant le texte !!!!

entryid is preferred identifier, id im xml document is 1 zu 1 und nicht zu gebrachen (legacy)

reference verweist auf identität

**important:**

here is the link to the picture (urlimage)

many cards = many transkribus pages per project_entry possible
