# Adding new terms to EJP-RD

```

```


### Adding Terms to the Import Files

Terms are imported to EJP-RD from other ontologies, but not all terms from external ontologies are imported. Occasionally, you will find that a valid identifier exists in an external ontology, but the identifier is not available in Protege because that term is not yet imported. To import a term from an external ontology:

1. Gitclone the repository on your local machine, and navigate to the cloned repository of EJP-Ontology i.e from the command line run $: gitclone https://github.com/EBISPOT/EJP-Ontology.git	


Navigate to the ontology folder on GitHub, located at [https://github.com/geneontology/go-ontology/tree/master/src/ontology/imports](https://github.com/geneontology/go-ontology/tree/master/src/ontology/imports).
2.	Look in the list of ontologies for the ontology that contains the term you wish to import.
3.	Identify the ```ontology_terms.txt``` file for the target ontology. For example, for the addition of a new taxon, the file can be found at [https://github.com/geneontology/go-ontology/blob/master/src/ontology/imports/ncbitaxon_terms.txt](https://github.com/geneontology/go-ontology/blob/master/src/ontology/imports/ncbitaxon_terms.txt).
4.	Click on the icon of a pencil in the upper right corner of the window to edit the file.
5.	Add the new term on the next available line at the bottom of the file.
6.	Click preview changes.
7.	You can now either commit the file directly to master or create a branch and a pull request as described before.

Adding Terms to the Import Files
Terms are imported to GO from other ontologies, but not all terms from external ontologies are imported. Occasionally, you will find that a valid identifier exists in an external ontology, but the identifier is not available in Protege because that term is not yet imported. To import a term from an external ontology:

Navigate to the imports folder on GitHub, located at https://github.com/geneontology/go-ontology/tree/master/src/ontology/imports.
Look in the list of ontologies for the ontology that contains the term you wish to import.
Identify the ontology_terms.txt file for the target ontology. For example, for the addition of a new taxon, the file can be found at https://github.com/geneontology/go-ontology/blob/master/src/ontology/imports/ncbitaxon_terms.txt.
Click on the icon of a pencil in the upper right corner of the window to edit the file.
Add the new term on the next available line at the bottom of the file.
Click preview changes.
You can now either commit the file directly to master or create a branch and a pull request as described before.


# Creating a New Ontology Term

See [Daily Workflow](http://go-ontology.readthedocs.io/en/latest/index.html#daily-workflow) for creating branches and basic Protégé instructions.

1. To create a new term, the 'Asserted view' must be active (not the 'Inferred view').

2. In the Class hierarchy window, click on the 'Add subclass' button at the upper left of the window.

3. A pop-up window will appear asking you to enter the Name of the new term. When you enter the term name, you will see your ID automatically populate the IRI box. Once you have entered the term, click 'OK' to save the new term. You will see it appear in the class hierarchy.

4. Navigate to the OBO annotation window.

5. In the OBO annotation window add:

    1. Namespace
       1. Begin typing one of the three branches (autocomplete will guide you to the correct term):
               - ```biological_process```
               - ```cellular _component```
               - ```molecular_function```
       2. For Type, select: ```xsd:string```

    2. Definition
       1. Click on the  ```+``` next to the Definition box
       2. Add the textual definition in the pop-up box.
       3. For Type, select: ```Xsd:string```
       4. Click OK.

     3. Add Definition References
        1. Click on the circle with the ‘Ref’ in it next to add Definition References and in the resulting pop-up click on the ```+``` to add a new ref, making sure they are properly formatted with a database abbreviation followed by a colon, followed by the text string or ID. Examples: ```GOC:bhm, PMID:27450630```.
         2. Select Type: ```xsd:string```
         3. Click OK.
         4. Add each definition reference separately by clicking on the ```+``` sign.

      4. Add synonyms and dbxrefs following the same procedure if they are required for the term.
6. If you have created a logical definition for your term, you can delete the asserted ```is_a``` parent in the ‘subclass of’ section. Once you synchronize the reasoner, you will see the automated classification of your new term. If the inferred classification doesn’t make sense, then you will need to modify the logical definition.

	```
    Protege tip:  If you need to create a logical definition using a GO term name that does not begin
    with an alphabetic character, e.g. GO:0004534 (5'-3' exoribonuclease activity), navigate to the
    View menu in Protege and select 'Render by entity IRI short name (Id).  This will allow you to
    enter a logical definition by entering the relations and term as IDs, e.g. RO_0002215 some GO_0004534.  
    Note the use of the underscore instead of the colon in the ID.  You can then return to the View
    menu to switch back to Render by label (rdfs:label) to see the term names.
	```

7. In some cases such as ```part_of``` relations based on external partonomies, it might be necessary to assert the ```part_of``` relationships. For example: ```‘heart valve development’ part_of some ‘heart development’```. In those cases, it is important to browse the external ontologies to be sure that nothing is missing.

8. When you have finished adding the term, you can hover over it in the class window to reveal its GO_id.

9. Save the file and ___return to your terminal window___. Then, type: ```git status```. This will confirm which file has been modified.

10. To see how the branch was modified, type: ```git diff```. In this case, go-edit.obo was modified. The text below is not the entire diff for this edit, but is an example. If the diff is very large, you will need to hit a space to continue to see it and then hit ‘q’ to get back to the prompt at the end of the diff file.

     ```

     ```

See [Daily Workflow](http://go-ontology.readthedocs.io/en/latest/index.html#daily-workflow) section for commit, push and merge instructions.
