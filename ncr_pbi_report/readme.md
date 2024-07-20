Taken from Microsoft and kept here as a abbreviated point of reference
[Link to Semantic Model](https://learn.microsoft.com/en-au/power-bi/developer/projects/projects-dataset#semantic-model-files)
[Link to Report files](https://learn.microsoft.com/en-au/power-bi/developer/projects/projects-report#report-files)

# Semantic Model files
### .pbi\localSettings.json
Contains semantic model settings that apply only for the current user and computer. It should be included in gitIgnore or other source control exclusions. By default, Git ignores this file.

### .pbi\editorSettings.json
Contains semantic model editor settings saved as part of the semantic model definition for use across users and environments.

### .pbi\cache.abf
An Analysis Services Backup (ABF) file containing a local cached copy of the model and data when it was last edited. It should be included in gitIgnore or other source control exclusions. By default, **Git ignores** this file.
Power BI Desktop can open a project without a cache.abf file. In that case, it opens the report connected to a model with its entire definition but without data. If a cache.abf exists, Power BI Desktop loads the data and overwrites the model definition with the content in model.bim.

### .pbi\unappliedChanges.json
Power BI Desktop allows you to save changes made in the Transform Data editor (Power Query) without first applying those changes to the data model.

### definition.pbism
Contains the overall definition of a semantic model and core settings.
This file also specifies the supported semantic model definition formats through the 'version' property.

### model.bim
This file is only available if the Power BI project is saved using the TMSL format. It contains a Tabular Model Scripting Language (TMSL) Database object definition of the project model.

### definition\ folder
This folder is only available if the Power BI project is saved using the TMDL format. It replaces the model.bim file.
This folder contains a Tabular Model Definition Language (TMDL) Database object definition of the project model.

### diagramLayout.json
Contains diagram metadata that defines the structure of the semantic model associated with the report. During PREVIEW, this file doesn't support external editing.

### .platform
Fabric platform file that holds properties vital for establishing and maintaining the connection between Fabric items and Git.

## Report files
### .pbi\localSettings.json
Contains report settings that apply only for the current user and local computer. It should be included in gitIgnore or other source control exclusions. By default, Git ignores this file.

### CustomVisuals\
A subfolder that contains metadata for custom visuals in the report. Power BI supports three kinds of custom visuals:

### RegisteredResources\
A subfolder that includes resource files specific to the report and loaded by the user, like custom themes, images, and custom visuals (pbiviz files).

### semanticModelDiagramLayout.json
Contains data model diagrams describing the structure of the semantic model associated with the report. During preview, this file doesn't support external editing.

### definition.pbir
Contains the overall definition of a report and core settings. This file also holds the reference to the semantic model used by the report. Power BI Desktop can open a pbir file directly, just the same as if the report were opened from a pbip file. Opening a pbir also opens the semantic model alongside if there's a relative reference using byPath.

### mobileState.json
Contains report appearance and behavior settings when rendering on a mobile device. This file doesn't support external editing.

### report.json
This file contains the report definition in the Power BI Report Legacy format (PBIR-Legacy) and doesn't support external editing.

### definition\ folder
This folder is only available if the Power BI project is saved using the Power BI enhanced report format (PBIR). It replaces the report.json file.

### .platform
Fabric platform file that holds properties vital for establishing and maintaining the connection between Fabric items and Git.