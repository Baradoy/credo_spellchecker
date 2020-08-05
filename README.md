# CredoSpellchecker

Spellchecker for [Credo](https://github.com/rrrene/credo)

This is a fairly simple spellchecker which uses word lists from http://app.aspell.net/create.

## Installation

Add `credo_spellchecker` to your list of dependencies in `mix.exs`.

```elixir
def deps do
    [
        {:credo_spellchecker, "~> 0.1"}
    ]
end
```

Add the `CredoSpellchecker.NoMisspelledWords` check to your list of Credo checks in `.credo.exs` (you can generate this file with `mix credo.gen.config` if you do not already have it.

```elixir
{CredoSpellchecker.NoMisspelledWords, [language_code: "en_CA", user_dictionary: "user_dictionary.list"]},
```

### Options

- `language_code` defines the language code of the dictionary to be used. Defaults to `en_CA` which is the language code for Canadian English.
- `user_dictionary` defines the location the user dictionary. Create a `user_dictionary.list` to add allowed words to. The user dictionary file should contain a word per line that should be allowed by the spellchecker. Alternatively, you can remove the `user_dictionary` and you do not have to create a user dictionary file.

## Case Insensitivity

The spell checker works by breaking down PascalCase and snake_case into downcased words that are checked individually.

## Supported Languages

Currently the Spellchecker only support `en_CA`,`en_GB` and `en_US`. That can easily be changed with a new library and a pull request. See the [priv/dictionaries/README.md](priv/dictionaries/README.md) for some helpful details.
