defmodule SpellCredo.DictionaryFilter do
  @moduledoc """
  Filters out words that are found in the given dictionaries, leaving only misspelled words.
  """

  def filter(sorted_word_list, []) do
    sorted_word_list
  end

  def filter(sorted_word_list, [current_stream | dictionary_streams]) do
    dictionary = Enum.to_list(current_stream)

    sorted_word_list
    |> filter_words_in_dictionary(dictionary, [])
    |> filter(dictionary_streams)
  end

  def filter_words_in_dictionary([], _, acc) do
    Enum.reverse(acc)
  end

  def filter_words_in_dictionary([word | words], [], acc) do
    filter_words_in_dictionary(words, [], [word | acc])
  end

  def filter_words_in_dictionary([current_word | words], [current_term | dictionary], acc)
      when current_word > current_term do
    filter_words_in_dictionary([current_word | words], dictionary, acc)
  end

  def filter_words_in_dictionary([current_word | words], [current_term | dictionary], acc)
      when current_word == current_term do
    filter_words_in_dictionary(words, [current_term | dictionary], acc)
  end

  def filter_words_in_dictionary([current_word | words], [current_term | dictionary], acc)
      when current_word < current_term do
    filter_words_in_dictionary(words, [current_term | dictionary], [current_word | acc])
  end
end
