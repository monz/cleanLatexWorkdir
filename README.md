clean up latex working directories
==================================

Known issues:
--------------
current version is not able to clean up paths with whitespace in its name

Usage:
------
<pre> ./cleanup.sh -p=&lt;path/to/clean&gt; [-f=&lt;path/to/fileExtensionFile&gt;] [-r/--recursive] </pre>

Info:
-----
If the file extension file is not set, a default file "filetypes.txt" must be present in the execution path.
