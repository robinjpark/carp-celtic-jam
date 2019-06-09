# Makefile to build Carp Celtic Jam Tune Book from abc source.
# Running 'make' builds two complete versions of the tune book:
# - A version suitable for printing.  This version includes a title page.
# - A version suitable for viewing on a computer or tablet.

PUBLISHED_FILES = $(PUB)/$(CCJTB)-printable.pdf $(PUB)/$(CCJTB)-tablet.pdf
CCJTB = carp-celtic-jam-tunebook

# File locations
SRC := ./src
OUT := ./output
PUB := ./publish

# Tools - All of these must be installed and in the path of the environment when invoking make.
ABCM2PS := abcm2ps
PS2PDF  := ps2pdf
PDFTK   := pdftk
PDFLATEX := pdflatex

# The default rule, which builds two versions of the tunebook for publication.
all: $(PUBLISHED_FILES)

# Printable version (cover page, tunes, index)
$(PUB)/$(CCJTB)-printable.pdf: $(SRC)/cover-page.pdf $(OUT)/blank.pdf $(OUT)/$(CCJTB).pdf $(OUT)/index.pdf | $(PUB)
	@$(PDFTK) $^ cat output $@
	@echo "Printer-friendly tunebook at $@"

# Tablet-friendly version (tunes and index)
$(PUB)/$(CCJTB)-tablet.pdf: $(OUT)/$(CCJTB).pdf $(OUT)/index.pdf | $(PUB)
	@$(PDFTK) $^ cat output $@
	@echo "Tablet-friendly tunebook at $@"

# Rule to convert postscript to pdf
$(OUT)/$(CCJTB).pdf: $(OUT)/$(CCJTB).ps | $(OUT)
	@echo "Converting $(notdir $<) to pdf"
	@$(PS2PDF) $< $@
	@$(PDFTK) $@ dump_data | grep NumberOfPages

# Rule to convert abc to postscript
$(OUT)/$(CCJTB).ps: $(SRC)/$(CCJTB).abc | $(OUT)
	@echo "Translating $(notdir $<) to postscript"
	@$(ABCM2PS) -q -O $@ $<
	@#Fix title in postscript file
	@sed -i 's/src\/carp-celtic-jam-tunebook.abc/Carp Celtic Jam Tune Book/' $@

# Rule to build a "blank" page from source
$(OUT)/blank.pdf: $(SRC)/blank.tex | $(OUT)
	@$(PDFLATEX) --interaction=batchmode -output-directory $(OUT) $< > /dev/null

# Rule to build a nicely formatted, and up-to-date index file
# from the source abc file.
$(OUT)/index.pdf: $(SRC)/$(CCJTB).abc tools/abcindex.py | $(OUT)
	@echo "Extracting tune index information from $(notdir $<)"
	@./tools/abcindex.py $< > $(OUT)/index.tex
	@echo "Creating pdf of tune index"
	@$(PDFLATEX) --interaction=batchmode $(OUT)/index.tex > /dev/null
	@rm -f index.log index.aux
	@mv -f index.pdf $@

# Rule to clean everything
.PHONY: clean
clean:
	@rm -rf $(OUT) $(PUB)

$(OUT):
	@mkdir -p $(OUT)

$(PUB):
	@mkdir -p $(PUB)
