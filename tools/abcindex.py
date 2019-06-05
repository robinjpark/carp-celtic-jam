#!/usr/bin/env python3
# A python script for generating an index file from an abc file.
# The index file is output in .tex format.

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
    elif title.endswith(", The"):
        return title[0:-5]
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

def extract_index(abc_file):
    current_page = 1
    title_pages = {}
    for aline in abc_file:
        if is_newpage_line(aline):
            current_page = page_number(aline, current_page)

        if is_title_line(aline):
            original_title = get_title(aline)
            index_title = adjusted_title(original_title)
            if index_title in title_pages:
                existing_page_number = title_pages[index_title]
                new_pages = "{0},{1}".format(existing_page_number,current_page)
                title_pages[index_title] = new_pages
            else:
                title_pages[index_title] = current_page

    return title_pages

def generate_tex_beginning():
    print('''
\\documentclass[11pt,fleqn]{article}

\\begin{document}
\\setlength{\\parindent}{0pt}
''')

def generate_tex_end():
    print('''
\end{document}
    ''')
def generate_index(abc_file):
    generate_tex_beginning()
    title_pages = extract_index(abc_file)

    current_letter = " "
    for title in sorted(title_pages.keys()):
        first_letter = title[0]
        if first_letter != current_letter:
            print('\\textbf{{{}}}\\newline'.format(first_letter))
            current_letter = first_letter
        print('{}\\dotfill{}\\newline'.format(title, title_pages[title]))

    generate_tex_end()

def main():
    check_usage()
    input_filename = get_input_filename()

    abc_file = open(input_filename, encoding="latin-1")
    generate_index(abc_file)

main()



