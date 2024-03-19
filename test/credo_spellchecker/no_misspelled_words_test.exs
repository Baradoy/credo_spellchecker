defmodule CredoSpellchecker.NoMisspelledWordsTest do
  use Credo.Test.Case

  alias CredoSpellchecker.NoMisspelledWords

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

  describe "issue messages and triggers should always be strings (and not bitstrings)" do
    # otherwise, credo chokes on output for the issue, which looks like this:
    #     (stdlib 5.2) re.erl:806: :re.run(<<70, 111, 117, 110, 100, 32, 109, 105, 115, 115, 112,
    # 101, 108, 108, 101, 100, 32, 119, 111, 114, 100, 32, 96, 103, 97, 114, 114, 121, 226, 96,
    # 46>>, {:re_pattern, 1, 1, 0, <<69, 82, 67, 80, 32, 1, 0, 0, 0, 8, 0, 32, 1, 136, 0, 0, 255,
    # 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0,
    # 0, 0, ...>>}, [{:capture, :all, :binary}, :global, {:offset, 0}]) (elixir 1.16.0)
    # lib/regex.ex:529: Regex.safe_run/3 (elixir 1.16.0) lib/regex.ex:516: Regex.scan/3 (credo
    # 1.7.5) lib/credo/cli/output/ui.ex:60: Credo.CLI.Output.UI.wrap_at/2 (credo 1.7.5)
    # lib/credo/cli/command/suggest/output/default.ex:209:
    # Credo.CLI.Command.Suggest.Output.Default.do_print_issue/4 (elixir 1.16.0) lib/enum.ex:987:
    # Enum."-each/2-lists^foreach/1-0-"/2 (credo 1.7.5)
    # lib/credo/cli/command/suggest/output/default.ex:136:
    # Credo.CLI.Command.Suggest.Output.Default.print_issues_for_category/5 (elixir 1.16.0)
    # lib/enum.ex:987: Enum."-each/2-lists^foreach/1-0-"/2
    #

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
      |> assert_issue(fn issue -> assert issue.trigger == "garry�" end)
      |> assert_issue(fn issue -> assert issue.message == "Found misspelled word `garry�`." end)
    end

    test "even when UTF-8 escaped punctuation is part of a misspelling" do
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
      |> assert_issue(fn issue -> assert issue.trigger == "�" end)
      |> assert_issue(fn issue -> assert issue.message == "Found misspelled word `�`." end)
    end
  end
end
