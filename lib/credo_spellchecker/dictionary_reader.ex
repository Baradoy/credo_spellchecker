defmodule CredoSpellchecker.DictionaryReader do
  @moduledoc """
  Reads dictionary files.

  Returns the streams for
    The language defined by the language_code option
    The user dictionary defined by the user_dictionary option
    The elixir specific dictionary in priv/dictionary/elixir.list
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
    |> stream_from_location()
  end

  def user_dictionary(params) when is_list(params) do
    user_dictionary(Keyword.get(params, :user_dictionary))
  end

  def user_dictionary(nil) do
    []
  end

  def user_dictionary(filename) do
    stream_from_location(filename)
  end

  def elixir_dictionary(_params) do
    "elixir"
    |> priv_dictionary_file()
    |> stream_from_location()
  end

  def assert_sorted(a, b) when a >= b do
    a
  end

  def assert_sorted(a, b) do
    raise "Dictionary is not sorted! `#{b}` should not be before `#{a}`. The NoMisspelledWords Credo check relies on dictionaries being sorted."
  end

  def priv_dictionary_file(name) do
    case :code.priv_dir(:credo_spellchecker) do
      dir when is_list(dir) ->
        List.to_string(dir) <> "/dictionaries/#{name}.list"

      {:error, :bad_name} ->
        "priv/dictionaries/#{name}.list"
    end
  end

  def stream_from_location(file_location) do
    file_location
    |> File.stream!()
    |> Stream.map(&String.downcase/1)
    |> Stream.map(&String.trim/1)
    |> Stream.scan(&assert_sorted/2)
  end
end
