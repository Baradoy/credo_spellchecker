# Dictionaries

## Copywrite

Any copywrite notices for a dictionary must be included with the dictionary. Include the notice in a file titled `\${language_code}.txt. For example the copywrite notice for en_CA.list is in en_CA.txt.

## Sorting

Dictionaries must be sorted. This
Consider using `LC_ALL=C sort -f` to produce sorted dictionaries.

## Filename

Dictionaries should be stored in `/priv/dictionaries`. The file name should be the language code with a `.list` extention.

## TODO

A better approach to this may be to take files from http://wordlist.aspell.net/ and create sorted lists from them at compile time.

It would also be good to include these as a zip file.
