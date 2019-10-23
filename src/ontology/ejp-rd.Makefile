## Customize Makefile settings for ejp-rd
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


../curation/ejp-rd_seed.txt: ../curation/ejp-rd_seed_table.tsv
	cat $< | cut -f2 -s | sed 's/\r//' | awk '{$$1=$$1};1' | sed '/^\(http\)/!d' | tr \| \\n  | sort | uniq > $@

seed.txt: ../curation/ejp-rd_seed.txt
	cp $< $@
