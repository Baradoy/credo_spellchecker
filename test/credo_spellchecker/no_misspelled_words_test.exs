defmodule CredoSpellchecker.NoMisspelledWordsTest do
  use Credo.Test.Case

  alias CredoSpellchecker.NoMisspelledWords

  # credo:disable-for-this-file

  @default_params [language_code: "en_CA", user_dictionary: "test/user_test_dictionary.list"]

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

    Is coffeffe a proper word?
    "

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords, @default_params)
    |> assert_issue(fn issue -> assert issue.trigger == "coffeffe" end)
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
    |> run_check(NoMisspelledWords, @default_params)
    |> refute_issues()
  end

  describe "issue messages and triggers should always be valid and printable strings" do
    test "even when UTF-8 punctuation is part of a misspelling" do
      """
      defmodule CredoTestModule do
        def example do
          %{
            # codepoint 8217, a.k.a. RIGHT SINGLE QUOTATION MARK
            "Garry’s" => ""
          }
        end
      end
      """
      |> to_source_file()
      |> run_check(NoMisspelledWords, @default_params)
      |> assert_issue(fn issue -> assert String.printable?(issue.message) end)
      |> assert_issue(fn issue -> assert String.valid?(issue.message) end)
      |> assert_issue(fn issue -> assert String.printable?(issue.trigger) end)
      |> assert_issue(fn issue -> assert String.valid?(issue.trigger) end)
      |> assert_issue(fn issue -> assert issue.trigger == "garry�" end)
      |> assert_issue(fn issue -> assert issue.message == "Found misspelled word `garry�`." end)
    end

    test "even when invalid escaped punctuation is part of a misspelling" do
      """
      defmodule CredoTestModule do
        def example do
          %{
            # codepoint 239, a.k.a. LATIN SMALL LETTER I WITH DIAERESIS
            "\uFEFFCategory" => "N-A Beverages"
          }
        end
      end
      """
      |> to_source_file()
      |> run_check(NoMisspelledWords, @default_params)
      |> assert_issue(fn issue -> assert String.printable?(issue.message) end)
      |> assert_issue(fn issue -> assert String.valid?(issue.message) end)
      |> assert_issue(fn issue -> assert String.printable?(issue.trigger) end)
      |> assert_issue(fn issue -> assert String.valid?(issue.trigger) end)
      |> assert_issue(fn issue -> assert issue.trigger == "�" end)
      |> assert_issue(fn issue -> assert issue.message == "Found misspelled word `�`." end)
    end
  end
end
