defmodule CredoSpellchecker.DictionaryReader do
  @moduledoc """
  Reads dictionary files.

  Returns the dictionary for
    The language defined by the language_code option
    The user dictionary defined by the user_dictionary option
    The elixir specific dictionary in priv/dictionary/elixir.list

    Most dictionaries are taken from http://app.aspell.net/create and are in a tar.gz format provided by that site.
  """

  def dictionaries(params) do
    [language_dictionary(params), user_dictionary(params), elixir_dictionary(params)]
  end

  def language_dictionary(params) when is_list(params) do
    language_dictionary(Keyword.get(params, :language_code))
  end

  def language_dictionary(language_code) do
    language_code
    |> priv_dictionary_file()
    |> dictionary_from_location()
  end

  def user_dictionary(params) when is_list(params) do
    user_dictionary(Keyword.get(params, :user_dictionary))
  end

  def user_dictionary(nil) do
    []
  end

  def user_dictionary(filename) do
    dictionary_from_location(filename)
  end

  def elixir_dictionary(_params) do
    "elixir"
    |> priv_dictionary_file()
    |> dictionary_from_location()
  end

  def priv_dictionary_file(name) do
    path = get_priv_path()

    file_name =
      path
      |> File.ls!()
      |> Enum.filter(fn file -> String.starts_with?(file <> ".", name) end)
      |> hd()

    path <> file_name
  end

  def dictionary_from_location(file_location) do
    if String.ends_with?(file_location, ".tar.gz") do
      dictionary_from_scowl_tar(file_location)
    else
      dictionary_from_list(file_location)
    end
  end

  defp dictionary_from_scowl_tar(filename) do
    {:ok, file} = :erl_tar.extract(filename, [:memory, :compressed])

    file
    |> Enum.find_value(fn
      {'SCOWL-wl/words.txt', dictionary} -> dictionary
      _ -> false
    end)
    |> String.split(~r/\s+/)
    |> Enum.map(&String.downcase/1)
    |> Enum.sort()
  end

  defp dictionary_from_list(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.downcase/1)
    |> Stream.map(&String.trim/1)
    |> Enum.sort()
  end

  defp get_priv_path() do
    case :code.priv_dir(:credo_spellchecker) do
      dir when is_list(dir) ->
        List.to_string(dir) <> "/dictionaries/"

      {:error, :bad_name} ->
        "priv/dictionaries/"
    end
  end
end
