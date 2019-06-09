#!/usr/bin/env python3
# A python script for generating an index file from an abc file.
# The index file is output in .tex format.

#########################################################
# WARNING:
#########################################################
# This script assumes that every new page in the abc file
# comes from an explicit %%newpage directive.
# If the abc typesetting program automatically inserts page breaks,
# This script will generate incorrect page numbers in the index!!!

import os
import sys

def eprint(*args, **kwargs):
    # Print to standard error.  Use like print()
    print(*args, file=sys.stderr, **kwargs)

def extract_index(abc_file_object):
    # Extracts a dictionary of {song_title: page_number} from an abc file
    def is_title_line(abc_line):
        # Returns True if the given line of the abc file is for a song title
        return abc_line.startswith("T:")

    def get_title(title_line):
        # Extracts the song title from a title line
        return title_line[2:].strip()

    def index_title(actual_title):
        # Adjusts a song title for inclusion in an index.
        if actual_title.startswith("The "):
            return actual_title[4:]
        elif actual_title.endswith(", The"):
            return actual_title[0:-5]
        elif actual_title.startswith("A "):
            return actual_title[2:]
        elif actual_title.startswith("'"):
            return actual_title[1:]
        else:
            return actual_title

    def is_newpage_line(line):
        # Returns True if the given line of the abc file is for a page break
        return line.startswith("%%newpage")

    # TODO: Is this needed?!?
    def next_page_number(newpage_line, current_page_number):
        # Given the '%%newpage' line and the current page number, return the next page number
        tokens = newpage_line.split()
        if len(tokens) == 1:
            return int(current_page_number) + 1
        else:
            return tokens[1];

    # start of extract_index() body
    current_page = 1
    song_page_numbers = {}
    for aline in abc_file_object:
        if is_newpage_line(aline):
            current_page = next_page_number(aline, current_page)

        if is_title_line(aline):
            original_title = get_title(aline)
            title = index_title(original_title)
            if title in song_page_numbers:
                existing_page_number = song_page_numbers[title]
                new_pages = "{0},{1}".format(existing_page_number,current_page)
                song_page_numbers[title] = new_pages
            else:
                song_page_numbers[title] = current_page

    return song_page_numbers

def create_tex_file(title_pages):
    def generate_tex_beginning():
        # Generates the beginning of the song index .tex file
        print('''
    \\documentclass[10pt,fleqn]{article}
    \\usepackage{multicol}
    \\setlength{\\columnsep}{1cm}
    \\usepackage[margin=0.5in]{geometry}

    \\begin{document}
    \\pagestyle{empty}
    \\setlength{\\parindent}{0pt}
    \\begin{center}
    \\LARGE
    \\textbf{Tune Index}
    \\normalsize
    \\end{center}
    \\begin{multicols}{3}
    \\hbadness=99999 % suppress warnings on letter headings
    ''')

    def generate_tex_body(title_pages):
        # Generates the body of the song index .tex file
        current_letter = " "
        for title in sorted(title_pages.keys()):
            first_letter = title[0]
            if first_letter != current_letter:
                print('\\vskip 5mm \\textbf{{{}}}\\newline'.format(first_letter))
                current_letter = first_letter
            print('{}\\dotfill{}\\newline'.format(title, title_pages[title]))

    def generate_tex_end():
        # Generates the end of the song index .tex file
        print('''
    \\end{multicols}
    \\end{document}
        ''')

    generate_tex_beginning()
    generate_tex_body(title_pages)
    generate_tex_end()

def check_song_page_numbers(index_dict):
    # Sanity check on the page numbers
    expectations = {
        "Blackthorne Stick": 1,
        "Ashokan Farewell": 48,
        "Ash Grove": 100,
        "Roddy McCorley": 162,
        "Lime Hill": 167,
        "Margaret Ann Robertson": 168,
        "Memories of St. Paul Island": 169,
        "Nancy March": 170,
        "Sherbrooke Reel": 171,
        "Log Driver's Waltz": 200,
        "Johnny Muise's Reel": 225,
        "Dying Year": 231,
    }
    for tune, page in expectations.items():
        #eprint('Checking "{}"...'.format(tune))
        if not tune in index_dict:
            sys.exit('{} is not in index'.format(tune))
        actual_page = index_dict[tune]
        if int(actual_page) != int(page):
            sys.exit('{} is on page {}--it should be on page {}!'.format(
                tune, actual_page, page))

def generate_index(abc_file_object):
    # generate an index.tex file from the abc file
    title_pages = extract_index(abc_file_object)
    check_song_page_numbers(title_pages)
    create_tex_file(title_pages)

def main():
    # The main() function of the script
    def check_usage():
        # Ensures that the script is called with exactly one parameter
        arg_count = len(sys.argv) - 1
        if arg_count != 1:
            print_usage()
            sys.exit(1)

    def print_usage():
        # Prints the usage of this script
        script_name = os.path.basename(sys.argv[0])
        print("usage: {0} [ABC_FILE]".format(script_name))

    def get_input_filename():
        # Gets the input filename from the command line arguments
        return sys.argv[1]

    # Start of main()
    check_usage()
    input_filename = get_input_filename()

    abc_file_object = open(input_filename, encoding="latin-1")
    generate_index(abc_file_object)

main()
