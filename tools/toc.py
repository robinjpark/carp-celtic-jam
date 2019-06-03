#!/usr/bin/env python3
# A python script for generating a table of contents from an abc file.

import os
import sys

def print_usage():
    script_name = os.path.basename(sys.argv[0])
    print("usage: {0} [ABC_FILE]".format(script_name))

def check_usage():
    arg_count = len(sys.argv) - 1
    if arg_count != 1:
        print_usage()
        sys.exit(1)

def get_input_filename():
    return sys.argv[1]

def is_title_line(abc_line):
    return abc_line.startswith("T:")

def get_title(title_line):
    return title_line[2:].strip()

def adjusted_title(title):
    if title.startswith("The "):
        return title[4:] + ", The"
    else:
        return title

def generate_toc(abc_file):
    for aline in abc_file:
        if is_title_line(aline):
            original_title = get_title(aline)
            #print (original_title)
            toc_title = adjusted_title(original_title)
            print (toc_title)

def main():
    check_usage()
    input_filename = get_input_filename()

    abc_file = open(input_filename, encoding="latin-1")
    generate_toc(abc_file)

main()



