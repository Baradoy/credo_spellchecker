# Dictionaries

## Adding Missing Words

If an Elixir term is missing, add it to `/priv/dictionaries/elixir.list` and create a PR.

## Adding New Dictionaries

Dictionaries should be stored in `/priv/dictionaries`. The file name should start with the the language_code. E.g. `en_CA.tar.gz` for the Canadian English dictionary.

- Dictionaries with the `.tar.gz` extension can be found at http://app.aspell.net/create. Those files are expected to have a file `SCOWL-wl/words.txt` inside the archive which contains the dictionary.
- Dictionaries with the `.list` extension should have a words per line.

The dictionary can be selected by changing the language_code param in `.credo.exs`.

```elixir
{CredoSpellchecker.NoMisspelledWords,
         [language_code: "en_GB"]}
```
