defmodule CredoSpellchecker.DictionaryReaderTest do
  use ExUnit.Case

  alias CredoSpellchecker.DictionaryReader

  test "Every included dictionary can be loaded (and is therefore sorted)" do
    directory = List.to_string(:code.priv_dir(:credo_spellchecker)) <> "/dictionaries"

    directory
    |> File.ls!()
    |> Enum.filter(fn file -> file =~ ~r/\.list$/ end)
    |> Enum.map(fn file ->
      file
      |> String.trim(".list")
      |> DictionaryReader.priv_dictionary_file()
    end)
    |> Enum.map(&DictionaryReader.dictionary_from_location/1)
    |> Enum.map(&Enum.to_list/1)
  end
end
