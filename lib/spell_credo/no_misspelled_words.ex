defmodule SpellCredo.NoMisspelledWords do
  use Credo.Check,
    base_priority: :high,
    category: :readability,
    explanations: [
      check: """
      Checks for misspelled words in your code.
      """,
      params: [
        language_code:
          "The language you want words to be checked against. Defaults to en_CA for Canadian English. Consider a PR to add a dictionary for languages not yet included.",
        user_dictionary: "Path to a dictionary of user allowed words."
      ]
    ],
    param_defaults: [language_code: "en_CA", user_dictionary: nil]

  alias SpellCredo.DictionaryReader

  @moduledoc """
  Words should not be misspelled.
  """
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    source_file
    |> Credo.Code.prewalk(&traverse/2)
    |> Enum.sort()
    |> SpellCredo.DictionaryFilter.filter(DictionaryReader.dictionaries(params))
    |> Enum.map(fn bad_word -> issue_for(bad_word, issue_meta) end)
  end

  defp traverse(atom, word_list) when is_atom(atom) do
    {[], to_words(atom) ++ word_list}
  end

  defp traverse(string, word_list) when is_binary(string) do
    {[], to_words(string) ++ word_list}
  end

  defp traverse({atom, rest}, word_list) when is_atom(atom) do
    {rest, to_words(atom) ++ word_list}
  end

  defp traverse({atom, line, rest}, word_list) when is_atom(atom) do
    {{atom, line, rest}, to_words(atom) ++ word_list}
  end

  defp traverse(other, word_list) do
    {other, word_list}
  end

  def to_words(atom) do
    atom
    |> to_string()
    |> Macro.underscore()
    |> String.split(~r/[\W\_]+/)
    |> Enum.filter(fn word -> String.length(word) > 0 end)
  end

  defp issue_for(trigger, issue_meta) do
    format_issue(
      issue_meta,
      message: "Found misspelled word `#{trigger}`.",
      trigger: "#{trigger}"
    )
  end
end
