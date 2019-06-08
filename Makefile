# Makefile to build Carp Celtic Jam Tune Book from abc source.

CCJTB := carp-celtic-jam-tunebook

# File locations
SRC_DIR := ./src
OUTPUT_DIR := ./output
PUBLISH_DIR := ./publish

# Tools
ABCM2PS := abcm2ps
PS2PDF := ps2pdf

all: $(PUBLISH_DIR)/$(CCJTB)-printable.pdf $(PUBLISH_DIR)/$(CCJTB)-tablet.pdf

$(PUBLISH_DIR)/$(CCJTB)-printable.pdf: $(SRC_DIR)/cover-page.pdf $(OUTPUT_DIR)/$(CCJTB).pdf $(OUTPUT_DIR)/index.pdf
	mkdir -p $(PUBLISH_DIR)
	pdftk $^ cat output $@

$(PUBLISH_DIR)/$(CCJTB)-tablet.pdf: $(OUTPUT_DIR)/$(CCJTB).pdf $(OUTPUT_DIR)/index.pdf
	mkdir -p $(PUBLISH_DIR)
	pdftk $^ cat output $@

$(OUTPUT_DIR)/$(CCJTB).pdf: $(OUTPUT_DIR)/$(CCJTB).ps
	$(PS2PDF) $< $@

$(OUTPUT_DIR)/$(CCJTB).ps: $(SRC_DIR)/$(CCJTB).abc
	mkdir -p $(OUTPUT_DIR)
	$(ABCM2PS) -O $@ $<
	sed -i 's/src\/carp-celtic-jam-tunebook.abc/Carp Celtic Jam Tune Book/' $@

$(OUTPUT_DIR)/index.pdf: $(SRC_DIR)/$(CCJTB).abc tools/abcindex.py
	./tools/abcindex.py $< > $(OUTPUT_DIR)/index.tex
	-pdflatex $(OUTPUT_DIR)/index.tex
	rm -f index.log index.aux
	mv -f index.pdf $@

clean:
	rm -rf $(OUTPUT_DIR) $(PUBLISH_DIR)
