# EJP-Ontology model for Semantic data model descriptor for Rare Diseases central registry / catalog
_To create a describable central catalogue of registries, biobanks, research infrastructure etc that have Interoperable datale (the 'I' in FAIR)._

An ontological model for describing resources for  Rare Diseases central registry including registries, biobanks, research infrastructures, genomes-phenome repositories, method standards, etc.  

## Goal
To build core schema and ontological model for the central registry - catalog

## Dependencies  
Types of resources that will be findable in the catalog include Orphanet, BBMRI, and Bio.tools. 
Standard registries to expose specific ERNs through this registry  e.g. Endo-ERN https://endo-ern.eu/specific-expertise/genetic-disorders-of-glucose-insulin-homeostasis/. specialist networks that connect people and services around a particular rare disease. 

## Stage 1:
Metadata to describe each of the resource types e.g. Biobank, Terminology/ontology, Gene database
The next step will be to break down common metadata elements shared across these resources. For example, can you search these resources by disease, and if so which disease ontology do they use. Other things you might search by would be genes, variants, phenotype/traits or tissue/sample type.
Identify the metadata fields and select the core ontology for use by the centralised registry. 
As individual resources may use their own ontology there will need to be a translation layer, possibly facilitated by OxO. 

