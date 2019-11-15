## Customize Makefile settings for ejp-rd
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


../curation/ejp-rd_seed.txt: ../curation/ejp-rd_seed_tab.tsv
	cat $< | cut -f3 -s | sed 's/\r//' | awk '{$$1=$$1};1' | sed '/^\(http\)/!d' | tr \| \\n  | sort | uniq > $@


seed.txt: ../curation/ejp-rd_seed.txt
	cp $< $@
	echo 'http://purl.obolibrary.org/obo/EJP-RD_00000000' >> $@

# The following ontologies were imported into the Ejp-rd ontology : DUO, EDAM, EFO, FOAF, HP, IAO, NCIT, OBI, OBIB, OMIABIS, and ORDO

COMPONENT_FILES= $(patsubst %.owl, components/%.owl, $(notdir $(wildcard components/*.owl)))


all_components: $(COMPONENT_FILES)
	echo $(COMPONENT_FILES)


EJP-RD_KEEPRELATIONS= ../curation/ejp-rd_relations.txt

components_sparql = $(patsubst %, components/%_seed_extract.sparql, $(IMPORTS))
components_seeds = $(patsubst %, components/%_simple_seed.txt, $(IMPORTS))
.PHONY: prepare_components
prepare_components:
	touch $(components_sparql)   &&\
	touch $(components_seeds)


components/%_seed_extract.sparql: seed.txt
	sh  ../scripts/generate_sparql_subclass_query.sh  seed.txt $@


components/%_simple_seed.txt: imports/%_import.owl components/%_seed_extract.sparql seed.txt
	$(ROBOT) query --input $< --select components/$*_seed_extract.sparql $@.tmp && \
	cat seed.txt $@.tmp | sort | uniq > $@  && rm $@.tmp

components/%.owl: imports/%_import.owl components/%_simple_seed.txt $(EJP-RD_KEEPRELATIONS)
	$(ROBOT) merge --input $<  \
		reason --reasoner ELK  \
		remove --axioms disjoint --trim false --preserve-structure false \
		remove --term-file $(EJP-RD_KEEPRELATIONS) --select complement --select object-properties --trim true \
		relax \
		filter --term-file components/$*_simple_seed.txt --select "annotations ontology anonymous self" --trim true --signature true \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
.PRECIOUS: components/%.owl


components/iao.owl: imports/iao_import.owl components/iao_simple_seed.txt $(EJP-RD_KEEPRELATIONS)
	$(ROBOT) merge --input $<  \
		reason --reasoner ELK  \
		remove --axioms disjoint --trim false --preserve-structure false \
		remove --term-file $(EJP-RD_KEEPRELATIONS) --select complement --select object-properties --trim true \
		relax \
		filter --term-file components/iao_simple_seed.txt --select "annotations ontology anonymous self" --trim true --signature true \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
.PRECIOUS: components/%.owl



imports/omiabis_terms_combined.txt: seed.txt imports/omiabis_terms.txt
	@if [ $(IMP) = true ]; then cat $^ | grep -v ^# | sort | uniq >  $@; fi


imports/omiabis_import.owl: mirror/omiabis.owl imports/omiabis_terms_combined.txt
	@if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/omiabis_terms_combined.txt --force true --method BOT \
		query --update ../sparql/inject-subset-declaration.ru \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@; fi
.PRECIOUS: imports/omiabis_import.owl

# convert imports to obo.
# this can be useful for spot-checks and diffs.
# we set strict mode to false by default. For discussion see https://github.com/owlcs/owlapi/issues/752
imports/omiabis_import.obo: imports/omiabis_import.owl
	@if [ $(IMP) = true ]; then $(ROBOT) convert --check false -i $< -f obo -o $@.tmp.obo && mv $@.tmp.obo $@; fi
imports/omiabis_import.json: imports/%_import.owl
	@if [ $(IMP) = true ]; then $(ROBOT) convert --check false -i $< -f json -o $@.tmp.json && mv $@.tmp.json $@; fi




components/omiabis.owl: imports/omiabis_import.owl components/omiabis_simple_seed.txt $(EJP-RD_KEEPRELATIONS)
	$(ROBOT) merge --input $<  \
		relax \
		remove --axioms disjoint \
		reason --reasoner ELK  \
		remove --axioms equivalent \
		remove --term-file $(EJP-RD_KEEPRELATIONS) --select complement --select object-properties --trim true \
		relax \
		filter --term-file components/omiabis_simple_seed.txt --select "annotations ontology anonymous self" --trim true --signature true \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
.PRECIOUS: components/%.owl

components/subclasses.owl: ../template/subclass_terms.csv
	$(ROBOT) -vvv template --template $<  --prefix "EFO: http://www.ebi.ac.uk/efo/EFO_" --prefix "OMIT: http://purl.obolibrary.org/obo/OMIT_"  --prefix "NCIT: http://purl.obolibrary.org/obo/NCIT_" --prefix "Orphanet: http://www.orpha.net/ORDO/Orphanet_" --prefix "snap: http://www.ifomis.org/bfo/1.1/snap#" annotate --ontology-iri $(ONTBASE)/$@ -o $@


$(ONT)-full.owl: $(SRC) components/subclasses.owl  ../curation/blacklist.txt
	$(ROBOT) merge --input $(SRC) -i components/subclasses.owl \
		remove --axioms equivalent --trim false \
		remove --term-file ../curation/blacklist.txt \
		reason --reasoner ELK --equivalent-classes-allowed all \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
#		relax \

../curation/retrieved_seed.txt: $(ONT)-full.owl  ../sparql/seed_class.sparql
	$(ROBOT) query -i $(ONT)-full.owl --query ../sparql/seed_class.sparql $@.tmp
	cat $@.tmp | sed 's/\r//' | sort | awk '{$$1=$$1};1' | sed '/^\(http\)/!d' | tr \| \\n  | sort | uniq > $@


../curation/curated_but_not_retrieved.txt: ../curation/retrieved_seed.txt ../curation/ejp-rd_seed.txt
	comm -13  ../curation/retrieved_seed.txt ../curation/ejp-rd_seed.txt > $@

../curation/curated_and_retrieved.txt: ../curation/curated_but_not_retrieved.txt ../curation/ejp-rd_seed.txt
	comm -13  ../curation/curated_but_not_retrieved.txt ../curation/ejp-rd_seed.txt > $@


all_diffs: ../curation/retrieved_seed.txt ../curation/curated_but_not_retrieved.txt ../curation/curated_and_retrieved.txt


update_repo:
	sh ../scripts/update_repo.sh
