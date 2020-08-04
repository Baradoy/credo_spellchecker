# CredoSpellchecker

Spellchecker for [Credo](https://github.com/rrrene/credo)

This is a fairly simple spell checker which uses wordlists from http://app.aspell.net.

## Installation

Add `credo_spellchecker` to your list of dependencies in `mix.exs`.

```elixir
def deps do
    [
        {:credo_spellchecker, "~> 0.1.0"}
    ]
end
```

Add the `CredoSpellchecker.NoMisspelledWords` check to your list of Credo checks in `.credo.exs` (you can generate this file with `mix credo.gen.config` if you do not already have it.

```elixir
{CredoSpellchecker.NoMisspelledWords, [language_code: "en_CA", user_dictionary: "user_dictionary.list"]},
```

Create a `user_dictionary.list` to use as your own user added words. Alternatively, you can remove the `user_dictionary` setting from `NoMisspelledWords` and you do not have to create a user dictionary file.

The user dictionary file should contain a word per line that should be allowed by the spellchecker.

e.g.

```
aboot
Baradoy
shoogle

```

## Case Insensitivity

The spell checker works by breaking down PascalCase and snake_case into downcased words that are checked individually. To keep the spellchecking fast, each dictionary

## Supported Languages

Currently the Spellchecker only supports Canadian English. That can easily be changed with a new library and a pull request. See the [priv/dictionaries/README.md](priv/dictionaries/README.md) for some helpful details.
