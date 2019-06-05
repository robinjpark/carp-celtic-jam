# Makefile to build Carp Celtic Jam tunebooks from abc source.
#

TITLE := carp-celtic-jam-tunebook

# File locations
SRC_DIR := ./src
OUTPUT_DIR := ./output
PUBLISH_DIR := ./publish

# Tools
ABCM2PS := abcm2ps
PS2PDF := ps2pdf

all: $(PUBLISH_DIR)/$(TITLE).pdf $(OUTPUT_DIR)/index.pdf

$(PUBLISH_DIR)/$(TITLE).pdf: $(OUTPUT_DIR)/$(TITLE).pdf
	mkdir -p $(PUBLISH_DIR)
	cp -f $< $@

$(OUTPUT_DIR)/$(TITLE).pdf: $(OUTPUT_DIR)/$(TITLE).ps
	$(PS2PDF) $< $@

$(OUTPUT_DIR)/$(TITLE).ps: $(SRC_DIR)/$(TITLE).abc
	mkdir -p $(OUTPUT_DIR)
	-$(ABCM2PS) -O $@ $<
	sed -i 's/src\/carp-celtic-jam-tunebook.abc/Carp Celtic Jam Tune Book/' $@

$(OUTPUT_DIR)/index.pdf: $(SRC_DIR)/$(TITLE).abc tools/abcindex.py
	./tools/abcindex.py $< > $(OUTPUT_DIR)/index.tex
	-pdflatex $(OUTPUT_DIR)/index.tex
	rm -f index.log index.aux
	mv -f index.pdf $(OUTPUT_DIR)/index.pdf

clean:
	rm -rf $(OUTPUT_DIR) $(PUBLISH_DIR)
