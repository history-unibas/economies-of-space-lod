Semantic analysis
=================

This document describes ...
.

# Mapping tables to entities

## StABS_Serie

This table is not used in the reduced database schema.

## StABS_Dossier

This table is not used in the reduced database schema. Required attributes are incorporated into the Project_Dossier and Transkribus_Page entities.

But this is the pivotal entity in the Archive, referring to the Dossier as a Record Set with URI.

&nbsp;

## Project_Dossier

Information über ein Gebäude aber auch Brunnen, Garten, unklar, Ansammlung von Liegenschaften



This table is mainly about the location of a thing.

The question is what the thing is : Facility or Location (cf. HTR annotation documentation)

How to provide a type / class?
No type -> use: CIDOC CRM E18 Physical Thing

**Description of the table**

Each element in this entity represents a physical dossier in the Historical Land Register of the City of Basel. Only dossiers that have at least one entry in the Project_Entry entity referring to the corresponding dossier are included in this entity. A dossier usually represents a building. Special dossiers contain a value in the 'specialType' attribute.


| **Column name** | **In Graph DB?** | **Remark** | **Description** |
|---------------|---------------|---------------|---------------|
| dossierId | yes | PRIMARY KEY | Project identifier for a dossier. Derived directly from 'stabsId', without spaces and with the number of characters standardised |
| locationUncorrectedAccuracy | yes |  | For locations entered manually in this project (attribute 'Project_Dossier.locationUncorrected'), this attribute specifies the degree of accuracy with which the location could be defined. Locations based on those held by the Land Registry and Surveying Office are marked as 'unbekannt', with dossiers lacking a location marked as 'nicht lokalisierbar'. |
| locationUncorrectedOrigin | yes |  | This attribute describes the basis on which the dossier's location (attribute 'Project_Dossier.locationUncorrected') was determined. Dossiers without a location have no value. |
| locationUncorrected<span style="color:red;">_wgs84</span> | yes | <span style="color:red;">- WGS 84 (EPSG:4326)<br>- stored as a string (not of the 'geometry' data type)<br>- Schema: "<http://www.opengis.net/def/crs/EPSG/0/4326> POINT (47.55514 7.58963)"<br>- Source: https://docs.ogc.org/is/22-047r1/22-047r1.html#_877a702f-f4d3-464c-81e9-d8a1f37a13f5</span> | This attribute contains the uncorrected geographical location of the dossier in the WGS 84  coordinate system (EPSG:4326).<br><br>The locations are based predominantly on data from the Land Registry and Surveying Office of the Canton of Basel-Stadt. For selected dossiers, as well as for dossiers without a location, locations were initially determined automatically on the basis of existing locations. Subsequently, the locations of selected dossiers were manually checked and set on the basis of the 1862 cadastral map ('Löffelplan'). The origin of each dossier location can be found in the 'Project_Dossier.locationUncorrectedOrigin' attribute. Different locations situated less than one meter apart were harmonised. For dossiers whose location was determined manually, the 'Project_Dossier.locationUncorrectedAccuracy' attribute provides information on the accuracy of the location. For locations taken from the Land Registry and Surveying Office, we are unable to provide any information (locationUncorrectedAccuracy='unknown').<br><br>During the development of the 'Project_Dossier.location' attribute, the locations of individual dossiers were manually improved. These corrections were not implemented in the 'Project_Dossier.locationUncorrected' attribute.|
| locationUncorrected<span style="color:red;">_lv95</span> | yes | <span style="color:red;">- LV95 (EPSG:2056)<br>- stored as a string (not of the 'geometry' data type)<br>- Schema: "<http://www.opengis.net/def/crs/EPSG/0/2056> Point(2611362.373451764 1267128.0894856066)"<br>- Source: https://docs.ogc.org/is/22-047r1/22-047r1.html#_877a702f-f4d3-464c-81e9-d8a1f37a13f5</span> | This attribute contains the uncorrected geographical location of the dossier in the LV95 coordinate system (EPSG:2056).<br><br>For further information, see the attribute 'Project_Dossier.locationUncorrected_wgs84'. |
| location<span style="color:red;">_wgs84</span> | yes | <span style="color:red;">dito locationUncorrected_wgs84</span> | This attribute contains the shifted geographical location of the dossier in the WGS 84 coordinate system (EPSG:4326).<br><br>Based on the attribute 'Project_Dossier.locationUncorrected_{wgs84,lv95}', the locations of selected dossiers have been adjusted with the aim of ensuring that fewer dossiers share the same location, thereby improving the display of the dossiers on a map.<br><br>Using an algorithm, a corresponding dossier was sought for any dossier in which the term 'neben' appears on the title page. If a 'neben dossier' was available, the location was shifted by a quarter of the distance in the direction of the 'neben dossier'. Example: 'St. Alban-Vorstadt Theil von 17 neben 15' (dossier: HGB_1_010_041, 'next to' dossier: 'St. Alban-Vorstadt 15', HGB_1_010_039). The distance of one quarter is chosen arbitrarily, but must be significantly less than half, as otherwise 'Teil von 15 neben 17' would end up at the same point. For dossiers whose titles comprise several addresses, corresponding dossiers were sought, each of which represents a single address. Where such dossiers were found, the geometric centre of gravity of the corresponding dossiers was defined as the shifted location of the linked dossier. Example: 'St. Alban-Graben 8, 10' (dossier: HGB_1_005_020; corresponding dossiers: 'St. Alban-Graben 8', HGB_1_005_019, and 'St. Alban-Graben 10', HGB_1_005_021). Selected files were then checked manually and repositioned based on the 1862 street plan. Manual checks were carried out on the locations of files that had been repositioned using the script, as well as on files where a repositioning was expected based on the information on the dossier's title page. In particular, a distinction was also made between front and back buildings where this was apparent. During the final manual review, many dossiers were identified that had not been located entirely correctly. Manual corrections were made primarily (but not exclusively) where the streets around 1862 differed significantly from the earlier street layout (examples: 'Eisengasse', 'untere Freie Strasse', 'Fischmarkt'). In these cases, the plan drawings held in the Historical Land Register of the City of Basel were consulted. The 'Project_Dossier.locationOrigin' attribute records which dossiers were repositioned using the algorithm and which were repositioned manually. Different locations situated less than one metre apart were harmonised.<br><br>Accuracy was not a specific objective when defining the locations. Although the dossiers were moved in a plausible direction and, in most cases, are now positioned more accurately than before (attribute 'Project_Dossier.locationUncorrected_{wgs84,lv95}'), this cannot be measured. The manual repositioning was carried out by eye rather than using precise measurements. |
| location<span style="color:red;">_lv95</span> | yes | <span style="color:red;">dito locationUncorrected_lv95</span> | This attribute contains the shifted geographical location of the dossier in the LV95 coordinate system (EPSG:2056).<br><br> For further information, see the attribute 'Project_Dossier.location_wgs84'. |
| locationOrigin | yes |  | This attribute records the shift in the adjusted location (attribute 'Project_Dossier.location') compared with the uncorrected location (attribute 'Project_Dossier.locationUncorrected'). |
| specialType | yes | FB: falls nicht 'normale' Liegenschaft, unbestimmte Liegenschaften, Brunnen | This attribute is used to identify features that do not represent a building, such as a river. These dossiers were identified on the basis of the information provided on the cover page of each dossier. |
| <span style="color:red;">StABS_Dossier.stabsId</span> | <span style="color:red;">yes</span> |  | An identifier for a dossier defined by the State Archives |
| <span style="color:red;">StABS_Dossier.linkRecord</span> | <span style="color:red;">yes</span> |  | URI of the relevant entry in the Basel-Stadt Linked Data Portal |

## Project_Entry

This table comprises two entities: the lrm:Expression on the card or ric:Record ; the xml digital transcription of part of the expression

Question about the 'year' column: date of the original document

**Description of the table**

Each element of this entity represents an entry recorded in the Historical Land Register of the City of Basel (HGB). Several entries may be documented on a single register tab ('page') of the HGB, or a single entry may span several pages. A page in the HGB is represented by an element in the 'Transkribus_Page' entity. If there are several entries on a single tab, these entries are not represented by multiple elements within this entity. The pages of the HGB considered are those that have been transcribed (see the 'Transkribus_Page' entity).


| **Column name** | **In Graph DB?** | **Remark** | **Description** |
|---------------|---------------|---------------|---------------|
| entryId | yes | PRIMARY KEY | Entry identifier |
| dossierId | yes | FOREIGN KEY (Project_Dossier.dossierId)| Identifier of the associated dossier (attribute 'Project_Dossier.dossierId') |
| year | yes |  | This attribute describes the year of the entry. The year was determined on the basis of the transcribed text, which is available in the Transkribus_Page.pageXml attribute. If the transcribed text contains text regions of the type 'header', the year corresponds to the first match of the pattern '1[0-9]{3}'. If no year is found and the search term 'Zins' appears in a text region (pattern '[Zz][iü]n[n]?s'), then the first year matching the same pattern is taken from the 'paragraph' text regions. Assumption: the relevant entry originates from the 'Zinsverzeichnis'. Selected years have been defined manually. Manually defined years have the value 'TRUE' in the 'Project_Entry.manuallyCorrected' attribute. Entries without a year contain further information in the 'Project_Entry.comment' attribute. |
| comment | yes |  | Comment providing further information on the entry's year. Most comments can be classified into one of the following categories:<br>- 'undatiert': No date is visible on the index card, or it is marked as undated.<br>- 'ungefähr': The year given in the entry is accompanied by the phrase 'um' or similar. The year is recorded in the 'Project_Entry.year' attribute. The comment makes it clear that this date is not precise.<br>- Specification of a century, e.g. 15th century: Instead of a precise year, the index card specifies a century. The century is mentioned in the comment.<br>- Correction: If the index card has been corrected by hand, the original date was recorded in the 'Project_Entry.year' attribute and the correction was added as a comment. |
| manuallyCorrected | yes |  | If the value is 'True', the year (attribute 'Project_Entry.year') and/or the association of the pages with this entry has been manually defined or edited. |
| language | yes |  | This attribute contains the probable language of the entry. The following values are available:<br>- 'german': The text region(s) probably contain text in German<br>- 'latin': The text region(s) probably contain text in Latin<br>- 'mixed': The text region(s) contain text in both German and Latin, or the language could not be determined with certainty.<br><br>The language is determined using an algorithm based on the text regions of the 'paragraph' type (contained in the 'Transkribus_Page.pageXml' attribute). The process has been optimised using the calculated confidence score to minimise the number of incorrect classifications as German and Latin. |
| source | yes |  | This attribute describes the source from which the entry originates.<br><br>The source references were identified as a separate text region during layout recognition and used for training. However, it transpired that the recognition did not work in around 15 per cent of the index cards and was also occasionally inaccurate in other instances. Using a sample of 2'000 recognised source references (of which 1'894 could be assigned to an institution or a source collection), supplemented by 65 multi-line source references (as a special case), a model was trained to extract the source reference from the full text of an entry and assign it to a source collection or an institution. Cases in which automatic recognition assigned multiple source references were reviewed and checked for plausibility; hence the value 'händisch durchgeschaut' (attribute 'Project_Entry.sourceOrigin'). The remaining entries - those without a recognised source reference or with a recognised source reference but no assigned institution - were supplemented manually. These included, on the one hand, references that were difficult to read (due to the poor condition of many index cards) and, on the other hand, references to rare collections that did not appear in the training data and were therefore correctly left unassigned.<br><br>Entries that can be attributed to more than one source have been separated by a semicolon. For entries without a source reference, the attribute value 'fehlt' has been used. |
| sourceOrigin | yes |  | This attribute specifies the type to which the source reference (attribute 'Project_Entry.source') has been assigned. |
| annotationManual | yes |  | Manually defined annotations of the transcribed text in XML format (ground truth). |
| annotationAutomated | yes |  | Automatically generated annotations of the transcribed text in XML format. Entries were annotated that are dated between 1400 and 1700 (attribute 'project_entry.year') and are written in German (attribute 'project_entry.language'). |


## Project_Period

Which entity : epistemic situation ?

**Description of the table**

Elements of this entity represent the 'validity periods' of dossiers (elements of the 'Project_Dossier' entity). This means that the dossier (Project_Dossier entity) represents the physical object (usually a building) during this period. This information makes it possible to determine how many dossiers exist in a given year and to visualise dossiers over time. A dossier may have several validity periods. Only dossiers that have an entry in the 'Project_Dossier' entity are shown.

Taking into account the relationships between dossiers (entity 'Project_Relationship'), care has been taken to ensure that dossiers immediately following one another in time do not leave a gap in the validity period and, conversely, that subsequent dossiers are not valid at the same time. If there is a time gap between a predecessor and a successor dossier, the 'Project_Period.yearTo' attribute of the predecessor was defined as the 'Project_Period.yearFrom' of the successor (the predecessor's period is defined as longer than the available data).


| **Column name** | **In Graph DB?** | **Remark** | **Description** |
|---------------|---------------|---------------|---------------|
| <span style="color:red;">projectPeriodId</span> | <span style="color:red;">yes</span> | <span style="color:red;">PRIMARY KEY<br>Regenerate (numbers 1, ..., n)</span> | Period identifier |
| dossierId | yes | FOREIGN KEY (Project_Dossier.dossierId) | Identifier of the associated dossier (attribute 'Project_Dossier.dossierId') |
| yearFrom | yes |  | The year from which the dossier exists |
| yearTo | yes |  | The year up to which the dossier exists |
| yearFromManuallyCorrected | yes |  | Indication of whether the 'Project_Period.yearFrom' attribute has been corrected manually |
| yearToManuallyCorrected | yes |  | Indication of whether the 'Project_Period.yearTo' attribute has been corrected manually |


## Project_Relationship

Meaning, about dossier Stabs or thing ?

**Description of the table**

Elements of this entity represent 'relationships' between dossiers (elements of the 'Project_Dossier' entity). A relationship exists between two dossiers when one dossier is derived from the other. For example, two relationships exist when a building is divided into two parts. Chronologically, one dossier 'exists' first. After the division, two dossiers exist. The original dossier therefore has one relationship with each of the dossiers resulting from the division. The attribute 'Project_Relationship.sourceDossierId' contains the 'dossierId' of the dossier from which the relationship originates ('source dossier', 'predecessor'). The attribute 'Project_Relationship.targetDossierId' contains the 'dossierId' of the dossier that follows the source dossier in time ('target dossier', 'successor'). A dossier can be linked to one or more source dossiers as well as target dossiers. Only relationships between dossiers that have an entry in the 'Project_Dossier' entity are shown.

If a dossier was included in another dossier from a certain point in time (or up to a certain point in time), the relationship can be correctly identified. However, it is not strictly correct to assume that it is a successor dossier (in the sense that one dossier ends and another begins immediately afterwards, i.e. there is no overlap). For this reason, these relationships have been recorded separately.

The relationships were determined on the basis of the information provided on the cover page of the dossiers. In many cases, this information is ambiguous and appears to vary in quality, which is why these relationships cannot be recorded entirely accurately. A certain margin of error is therefore inherent.


| **Column name** | **In Graph DB?** | **Remark** | **Description** |
|---------------|---------------|---------------|---------------|
| <span style="color:red;">projectRelationshipId</span> | <span style="color:red;">yes</span> | <span style="color:red;">PRIMARY KEY<br>Regenerate (numbers 1, ..., n)</span> | Relationship identifier |
| sourceDossierId | yes | FOREIGN KEY (Project_Dossier.dossierId) | Identifier of the source dossier (attribute 'Project_Dossier.dossierId') of the relationship |
| targetDossierId | yes | FOREIGN KEY (Project_Dossier.dossierId) | Identifier of the target dossier (attribute 'Project_Dossier.dossierId') of the relationship |


## Transkribus_Collection

This entity is not used in the reduced database schema.


## Transkribus_Document

This entity is not used in the reduced database schema.


## Transkribus_Page

??? Digital object ?

**Description of the table**

Elements of this entity represent transcribed digital copies of a register page (front or back) from the Historical Land Register of the City of Basel. The following pages were excluded from the transcription:
- Title pages, i.e. pages 1 and 2 of a dossier
- 19th-century fire insurance registers ('Brandlagerbücher')
- Index cards relating to the Reichspfennig ('Reichspfennigverzeichnisse') from 1497
- Parcel information containing details of dossiers that were temporarily merged, or details of building history such as dates found
- Pages belonging to dossiers identified as 'index of persons' or 'site plan'
- All pages of a dossier where the dossier represents a property located outside the city walls


| **Column name** | **In Graph DB?** | **Remark** | **Description** |
|---------------|---------------|---------------|---------------|
| pageId | yes | PRIMARY KEY | Page identifier |
| pageNr | yes |  | Page number of the page in the dossier |
| entryId | yes | FOREIGN KEY  | Identifier of the corresponding entry (attribute 'Project_Entry.entryId') |
| <span style="color:red;">StABS_Dossier.stabsId</span> | <span style="color:red;">yes</span> | <span style="color:red;"></span> | An identifier for a dossier defined by the State Archives |
| <span style="color:red;">StABS_Dossier.linkRecord</span> | <span style="color:red;">yes</span> | <span style="color:red;"></span> | URI of the relevant entry in the Basel-Stadt Linked Data Portal |
| <span style="color:red;">Transkribus_Transcript.pageXml</span> | <span style="color:red;">yes</span> | <span style="color:red;">pageXml of the latest transcript</span> | pageXML generated by the Transkribus platform, which contains the results of the layout and text recognition (where applicable) |


## Transkribus_Transcript

This entity is not used in the reduced database schema. Only the last transcription is migrated. Therefore merging with Transkribus_Page is possible.



| **Column name** | **In Graph DB?** | **Remark**  |
| --------------- | ---------------- | ----------- |
| key             | no               | PRIMARY KEY |
| tsId            | no               | PRIMARY KEY |
| pageId          | no               | FOREIGN KEY |
| parentTsId      | no               |             |
| pageXml         | yes              |             |
| status          | no               |             |
| timestamp       | no               |             |
| htrModel        | no               |             |

## Transkribus_TextRegion

This entity is not used in the reduced database schema.


# Definition of the reduced database schema

![Diagramm](database_diagram_reduced.drawio.svg)

```sql
CREATE TABLE graph.project_dossier (
	dossierid varchar(15) NOT NULL,
	locationuncorrectedaccuracy varchar(50) NULL,
	locationuncorrectedorigin varchar(100) NULL,
	locationuncorrected_wgs84 varchar(100) NULL,
	locationuncorrected_lv95 varchar(100) NULL,
	location_wgs84 varchar(100) NULL,
	location_lv95 varchar(100) NULL,
	locationorigin varchar(30) NULL,
	specialtype varchar(50) NULL,
	stabsid varchar(15) NOT NULL,
	linkrecord varchar(50) NOT NULL,
	CONSTRAINT project_dossier_pkey PRIMARY KEY (dossierid)
);
CREATE TABLE graph.project_period (
	projectperiodid INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
	dossierid varchar(15) NOT NULL,
	yearfrom int2 NULL,
	yearto int2 NULL,
	yearfrommanuallycorrected bool DEFAULT false NOT NULL,
	yeartomanuallycorrected bool DEFAULT false NOT NULL,
	CONSTRAINT project_period_dossierid_fkey FOREIGN KEY (dossierid) REFERENCES graph.project_dossier(dossierid)
);
CREATE TABLE graph.project_relationship (
	projectrelationshipid INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
	sourcedossierid varchar(15) NOT NULL,
	targetdossierid varchar(15) NOT NULL,
	CONSTRAINT project_relationship_sourcedossierid_fkey FOREIGN KEY (sourcedossierid) REFERENCES graph.project_dossier(dossierid),
	CONSTRAINT project_relationship_targetdossierid_fkey FOREIGN KEY (targetdossierid) REFERENCES graph.project_dossier(dossierid)
);
CREATE TABLE graph.project_entry (
	entryid varchar(45) DEFAULT uuid_with_postfix() NOT NULL,
	dossierid varchar(15) NOT NULL,
	"year" int2 NULL,
	"comment" varchar(100) NULL,
	manuallycorrected bool DEFAULT false NOT NULL,
	"language" varchar(20) NULL,
	"source" varchar(100) NULL,
	sourceorigin varchar(30) NULL,
	annotationmanual xml NULL,
	annotationautomated xml NULL,
	CONSTRAINT project_entry_pkey PRIMARY KEY (entryid),
	CONSTRAINT project_entry_dossierid_fkey FOREIGN KEY (dossierid) REFERENCES graph.project_dossier(dossierid)
);
CREATE TABLE graph.transkribus_page (
	pageid int4 NOT NULL,
	pagenr int2 NOT NULL,
	entryid varchar(45) NULL,
	stabsid varchar(15) NOT NULL,
	linkrecord varchar(50) NOT NULL,
	pagexml xml NOT NULL,
	CONSTRAINT transkribus_page_pkey PRIMARY KEY (pageid),
	CONSTRAINT transkribus_page_entryid_fkey FOREIGN KEY (entryid) REFERENCES graph.project_entry(entryid)
);
```

# Data migration to a reduced database schema

```sql
INSERT INTO graph.project_dossier
SELECT
	pd.dossierid,
	pd.locationuncorrectedaccuracy,
	pd.locationuncorrectedorigin,
	'http://www.opengis.net/def/crs/EPSG/0/4326 ' || ST_AsText(ST_Transform(pd.locationuncorrected, 4326)) AS locationuncorrected_wgs84,
	'http://www.opengis.net/def/crs/EPSG/0/2056 ' || ST_AsText(pd.locationuncorrected) AS locationuncorrected_lv95,
	'http://www.opengis.net/def/crs/EPSG/0/4326 ' || ST_AsText(ST_Transform(pd."location", 4326)) AS location_wgs84,
	'http://www.opengis.net/def/crs/EPSG/0/2056 ' || ST_AsText(pd."location") AS location_lv95,
	pd.locationorigin,
	pd.specialtype,
	sd.stabsid,
	sd.linkrecord FROM public.project_dossier pd
JOIN stabs_dossier sd 
ON pd.dossierid = sd.dossierid;

INSERT INTO graph.project_relationship (sourcedossierid, targetdossierid)
SELECT
	sourcedossierid,
	targetdossierid
FROM public.project_relationship pr;

INSERT INTO graph.project_period (dossierid, yearfrom, yearto, yearfrommanuallycorrected, yeartomanuallycorrected)
SELECT
	dossierid,
	yearfrom,
	yearto,
	yearfrommanuallycorrected,
	yeartomanuallycorrected
FROM public.project_period pp;

INSERT INTO graph.project_entry
SELECT
	entryid,
	dossierid,
	"year",
	"comment",
	manuallycorrected,
	"language",
	"source",
	sourceorigin,
	annotationmanual,
	annotationautomated
FROM public.project_entry pe;

INSERT INTO graph.transkribus_page
WITH latest_transcripts AS (
	SELECT DISTINCT ON (tt.pageid) 
	    tt.pageid, 
	    tt.pagexml
	FROM public.transkribus_transcript tt
	ORDER BY tt.pageid, tt."timestamp" DESC
)
SELECT
	tp.pageid,
	tp.pagenr,
	tp.entryid,
	sd.stabsid,
	sd.linkrecord,
	lt.pagexml
FROM public.transkribus_page tp
JOIN public.transkribus_document td ON tp.docid = td.docid
JOIN public.stabs_dossier sd ON td.title = sd.dossierid
JOIN latest_transcripts lt ON tp.pageid = lt.pageid;
```
