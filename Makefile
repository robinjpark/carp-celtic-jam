# Makefile to build Carp Celtic Jam Tune Book from abc source.
# Running 'make' builds two complete versions of the tune book:
# - A version suitable for printing.  This version includes a title page.
# - A version suitable for viewing on a computer or tablet.

CCJTB := carp-celtic-jam-tunebook

PUBLISHED_FILES = $(PUBLISH_DIR)/$(CCJTB)-printable.pdf $(PUBLISH_DIR)/$(CCJTB)-tablet.pdf

# File locations
SRC_DIR := ./src
OUTPUT_DIR := ./output
PUBLISH_DIR := ./publish

# Tools - All of these must be installed and in the path of the environment when invoking make.
ABCM2PS := abcm2ps
PS2PDF  := ps2pdf
PDFTK   := pdftk
PDFLATEX := pdflatex

# The default rule, which builds two versions of the tunebook for publication.
all: $(PUBLISHED_FILES)

# Printable version (cover page, tunes, index)
$(PUBLISH_DIR)/$(CCJTB)-printable.pdf: $(SRC_DIR)/cover-page.pdf $(OUTPUT_DIR)/blank.pdf $(OUTPUT_DIR)/$(CCJTB).pdf $(OUTPUT_DIR)/index.pdf
	@mkdir -p $(PUBLISH_DIR)
	@$(PDFTK) $^ cat output $@
	@echo "Printer-friendly tunebook at $@"

# Tablet-friendly version (tunes and index)
$(PUBLISH_DIR)/$(CCJTB)-tablet.pdf: $(OUTPUT_DIR)/$(CCJTB).pdf $(OUTPUT_DIR)/index.pdf
	@mkdir -p $(PUBLISH_DIR)
	@$(PDFTK) $^ cat output $@
	@echo "Tablet-friendly tunebook at $@"

# Rule to convert postscript to pdf
$(OUTPUT_DIR)/$(CCJTB).pdf: $(OUTPUT_DIR)/$(CCJTB).ps
	@echo "Converting $(notdir $<) to pdf"
	@$(PS2PDF) $< $@
	@$(PDFTK) $@ dump_data | grep NumberOfPages

# Rule to convert abc to postscript
$(OUTPUT_DIR)/$(CCJTB).ps: $(SRC_DIR)/$(CCJTB).abc
	@mkdir -p $(OUTPUT_DIR)
	@echo "Translating $(notdir $<) to postscript"
	@$(ABCM2PS) -q -O $@ $<
	@#Fix title in postscript file
	@sed -i 's/src\/carp-celtic-jam-tunebook.abc/Carp Celtic Jam Tune Book/' $@

# Rule to build a "blank" page from source
$(OUTPUT_DIR)/blank.pdf: $(SRC_DIR)/blank.tex
	@$(PDFLATEX) --interaction=batchmode -output-directory $(OUTPUT_DIR) $< > /dev/null

# Rule to build a nicely formatted, and up-to-date index file
# from the source abc file.
$(OUTPUT_DIR)/index.pdf: $(SRC_DIR)/$(CCJTB).abc tools/abcindex.py
	@echo "Extracting tune index information from $(notdir $<)"
	@./tools/abcindex.py $< > $(OUTPUT_DIR)/index.tex
	@echo "Creating pdf of tune index"
	@$(PDFLATEX) --interaction=batchmode $(OUTPUT_DIR)/index.tex > /dev/null
	@rm -f index.log index.aux
	@mv -f index.pdf $@

# Rule to clean everything
clean:
	@rm -rf $(OUTPUT_DIR) $(PUBLISH_DIR)
