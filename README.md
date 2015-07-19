clean up latex working directories
==================================

Known issues:
--------------
current version is not able to clean up paths with whitespace in its name

Usage:
------
./cleanup.sh -p=\<path/to/clean\> [-f=\<path/to/fileExtensionFile\>] [-r/--recursive]

Info:
-----
If the file extension file is not set, a default file "filetypes.txt" must be present in the execution path.
