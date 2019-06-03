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
        return title[4:]
    else:
        return title

def is_newpage_line(aline):
    return aline.startswith("%%newpage")

def page_number(newpage_line, current_page_number):
    tokens = newpage_line.split()
    if len(tokens) == 1:
        return int(current_page_number) + 1
    else:
        return tokens[1];

def generate_toc(abc_file):
    current_page = 1
    title_pages = {}
    titles = []
    for aline in abc_file:
        if is_newpage_line(aline):
            current_page = page_number(aline, current_page)

        if is_title_line(aline):
            original_title = get_title(aline)
            toc_title = adjusted_title(original_title)
            print('title "{}", page {}'.format(toc_title, current_page))
            titles.append(toc_title)
            title_pages[toc_title] = current_page

    titles.sort()
    for title in titles:
        print('"{}": page {}'.format(title, title_pages[title]))

def main():
    check_usage()
    input_filename = get_input_filename()

    abc_file = open(input_filename, encoding="latin-1")
    generate_toc(abc_file)

main()



