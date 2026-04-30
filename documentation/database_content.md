# Database structure and content

Back to [home](../README.md)

## Cards examples

See here some [examples of transcriptions](cards_examples.md)

## Database tables

### stabs_serie

Content:

* Physical collection of folders (aligned with physical set)
* It is dedicated to a street, a square, etc.
* It has a record in the digital archive and on website

Properties:

* Use the *srieid* column as URI ?
* title as standard label
* owl:sameAs to *link*

### stabs_dossier

Elements of the entity StABS_Dossier ***represent a building, address or further information of a street***. The elements are at the "Dossier" level at the State Archives. Dossiers that do not have subordinate units at the State Archives are not represented in this table.

#### Relevant columns

* dossierid is the primary key in the connection to the other tables
  * Example: HGB_1_024_001
* serieid: reference to the StABS series
* title: generally the Address or similar
  * Example: Barfüsserplatz: Übersicht, Barfüsserplatz Theil von 5, Ecke und neben 6
* link: URL to StABS record
  * Example: HGB_1_024_001 -> [https://ld.bs.ch/ais/Record/1462466](https://ld.bs.ch/ais/Record/1462466https:/)
  * rdf:type [https://www.ica.org/standards/RiC/ontology#RecordSet](https://www.ica.org/standards/RiC/ontology#RecordSet)
* owner1862: von Hand hinzugefügt aus dem Lesesaal (Jonas ???)

Possible alignment: intentional or physical collection ?
A physical collection avec cards ?

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

### project_relationship

Associates source with target dossier.

Kind of relationship: separate addresses, unify addresses (houses as different addresses at different times, splitted, then merged or resplitted)

'dossier' change over time documented here

### project_entry

"Elements of the Project_Entry table represent an entry recorded in the HGB. __*Several entries can be documented on one register card of the HGB or one entry can extend over several pages/register cards*__ [???]. A page in the HGB is represented by an element in the table Transkribus_Page. If there are ***several entries*** on a register card, these entries are not currently represented by several elements in this table."

Rein semantisches Konzept ?!?

IN reality this is the place where you find the encoded XML document, therefore map to Linguistic object ? ou Information object

### transkribus_page

* in meinsetn Fällen ein Eintrag (project-entry) pro Registerkarte
* eintrag : einleitungs datum, paragraph, credit, footer (types von **transkribus region**)
* manchmal ein Eintrag über mehrere seiten = bilder (transkribus pages)
* sehr selten : eine seite / kard : mehrer einträge (nicht berücksichtigt, nicht in der Datenbankstruktur)

Notes concernant le texte !!!!

entryid is preferred identifier, id im xml document is 1 zu 1 und nicht zu gebrachen (legacy)

reference verweist auf identität
