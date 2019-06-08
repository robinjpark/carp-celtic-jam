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
	@mkdir -p $(PUBLISH_DIR)
	@pdftk $^ cat output $@
	@echo "Printer-friendly tunebook at $@"

$(PUBLISH_DIR)/$(CCJTB)-tablet.pdf: $(OUTPUT_DIR)/$(CCJTB).pdf $(OUTPUT_DIR)/index.pdf
	@mkdir -p $(PUBLISH_DIR)
	@pdftk $^ cat output $@
	@echo "Tablet-friendly tunebook at $@"

$(OUTPUT_DIR)/$(CCJTB).pdf: $(OUTPUT_DIR)/$(CCJTB).ps
	@echo "Converting $(notdir $<) to pdf"
	@$(PS2PDF) $< $@

$(OUTPUT_DIR)/$(CCJTB).ps: $(SRC_DIR)/$(CCJTB).abc
	@mkdir -p $(OUTPUT_DIR)
	@echo "Translating $(notdir $<) to postscript"
	@$(ABCM2PS) -q -O $@ $<
	@#Fix title in postsript file
	@sed -i 's/src\/carp-celtic-jam-tunebook.abc/Carp Celtic Jam Tune Book/' $@

$(OUTPUT_DIR)/index.pdf: $(SRC_DIR)/$(CCJTB).abc tools/abcindex.py
	@echo "Extracting tune index information from $(notdir $<)"
	@./tools/abcindex.py $< > $(OUTPUT_DIR)/index.tex
	@echo "Creating pdf of tune index"
	@pdflatex --interaction=batchmode $(OUTPUT_DIR)/index.tex > /dev/null
	@rm -f index.log index.aux
	@mv -f index.pdf $@

clean:
	@rm -rf $(OUTPUT_DIR) $(PUBLISH_DIR)
