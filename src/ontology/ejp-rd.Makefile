## Customize Makefile settings for ejp-rd
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


../curation/ejp-rd_seed.txt: ../curation/ejp.txt
	cat $< | cut -f1 -s | sed '/^\(http\)/!d' | sort | uniq > $@

seed.txt: ../curation/ejp-rd_seed.txt
	cp $< $@
