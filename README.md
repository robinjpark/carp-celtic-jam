# Carp Celtic Jam
This repository contains the book of tunes for the Carp Celtic Jam (https://carpcelticjam.wixsite.com/carpjam).

This repository contains the complete tunebook in .abc format, and instructions and tools for converting the tunes into useful .pdf files for printing or viewing on a tablet or computer.

Those files can them be uploaded onto the Carp Celtic Jam's website for public
access.

# Requirements to Build Tune Book
The build process assumes a Linux environment.  In theory, any Linux system should be capable of building the tune book.  In practice, good luck.

The following tools must be available:
- abcm2ps
- ps2pdf
- pdftk
- pdflatex
- make

The build process was originally (circa 2019) tested on a Linux system running Ubuntu 18.04.2 LTS.  

More recently (2024), it was tested on a Windows 10 PC running Ubuntu 24.04.1 LTS within WSL2.  I had to download/build/install abcm2ps from its source (https://github.com/lewdlime/abcm2ps) to get it to work.  The easier installation suggested by Ubuntu did not work.

# Instructions to Build the Tune Book
1. Clone the repo.
1. Run the command 'make' from the directory containing the repo.
1. The output files suitable for publication are created in the directory 'publish'.

# Instructions to Publish the Tune Book
Copy the three files from the 'publish' directory to the Carp Celtic Jam Google Drive storage.  That will overwrite the existing published versions with the newer versions.  The links from the CCJ website will then automatically point to this newer versions.  Don't forget to update (and publish) the change log!

# Disclaimer
This package of tunes was created for informal, jamming purposes only and is not to be sold.  Some of these tunes are copyrighted, but may not indicate the composer's name.  The fact that a tune appears without a composer name does not imply that it is in the public domain. Therefore, if you intend to perform, record or publish any of these tunes, it is your responsibility to acquire the necessary permissions, if applicable.
