# Makefile to build Carp Celtic Jam tunebooks from abc source.
#

TITLE := carp-celtic-jam

# File locations
SRC_DIR := ./src
OUTPUT_DIR := ./output

# Tools
ABCM2PS := abcm2ps
PS2PDF := ps2pdf

all: $(OUTPUT_DIR)/$(TITLE).pdf

$(OUTPUT_DIR)/$(TITLE).pdf: $(OUTPUT_DIR)/$(TITLE).ps
	$(PS2PDF) $< $@

$(OUTPUT_DIR)/$(TITLE).ps: $(SRC_DIR)/$(TITLE)-all-tunes.abc
	-$(ABCM2PS) -O $@ $<

clean:
	rm -f $(OUTPUT_DIR)/*
