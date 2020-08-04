defmodule CredoSpellchecker.NoMisspelledWordsTest do
  use Credo.Test.Case

  alias CredoSpellchecker.NoMisspelledWords

  @default_params [language_code: "en_CA", user_dictionary: nil]

  test "Accepts correctly spelled words" do
    """
    @moduledoc "Information about the module goes here."

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here honour"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords, @default_params)
    |> refute_issues()
  end

  test "Rejects incorrectly spelled words" do
    """
    @moduledoc "Information about the module goes here

    Is inexorablabiliabuddy a proper word?
    "

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords, [])
    |> assert_issue(fn issue -> assert issue.trigger == "inexorablabiliabuddy" end)
  end

  test "Uses user_dictionary to accept words" do
    """
    @moduledoc "Information about the module goes here

    Is inexorablabiliabuddy a proper word?
    "

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords,
      language_code: "en_CA",
      user_dictionary: "test/user_test_dictionary.list"
    )
    |> refute_issues()
  end

  test "Changing the language code rejects words" do
    """
    defmodule Honour do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords, language_code: "en_US")
    |> assert_issue(fn issue -> assert issue.trigger == "honour" end)
  end
end
