

## Changes november 2025

These docs will deviate slightly from the ones we provided you previously:

Some **span-Elements now feature the "norm"-Attribute with Normalization-Information**. At the moment, these are simply unique strings until we have a table for the occupations.

These files currently don't have a custom namespace

They don't have a TEI-Header

I've suggested to Jonas that he should move the Ground Truth XML to a separate field so we don't mix automatically annotated and manually annotated data

I also just realized that the **postprocessing script doesn't strictly requires all reference-elements to have head, so it can happen that sometimes a reference element doesn't have one.**

I have integrated the automatically annotated documents received from Ismail into the hgb_graph_development database.
You can find the corresponding XMLs in project_entry.**annotation_automated**
This column is no longer an array
In 67 cases, the XML document could not be linked (correctly) to database entries (see attachment). Ismail is looking into these cases.
The manually created annotations can now also be found under '**annotation_manual**' (no longer an array).
I have left the previous 'annotation' column as it is, as there are dependencies (it can also be deleted if desired).
Zur Info (insbesondere an @Ismail und @Tobias_H): Ich konnte die restlichen (22) Seiten transkribieren und somit der Prozess abschliessen.