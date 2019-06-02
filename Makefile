# Makefile to build Carp Celtic Jam tunebooks from abc source.
#

TITLE := carp-celtic-jam

# File locations
SRC_DIR := ./src
OUTPUT_DIR := ./output

# Tools
ABCM2PS := abcm2ps

all: $(OUTPUT_DIR)/$(TITLE).ps

$(OUTPUT_DIR)/$(TITLE).ps: $(SRC_DIR)/$(TITLE)-all-tunes.abc
	$(ABCM2PS) -O $(OUTPUT_DIR)/$(TITLE).ps $(SRC_DIR)/$(TITLE)-all-tunes.abc

clean:
	rm -f $(OUTPUT_DIR)/$(TITLE).ps
