defmodule CredoSpellchecker.MixProject do
  use Mix.Project

  def project do
    [
      app: :credo_spellchecker,
      version: "0.1.0",
      elixir: "~> 1.10",
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/Baradoy/credo_spellchecker"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4"}
    ]
  end

  defp description() do
    """
    A Spellchecker rule for Credo
    """
  end

  defp package() do
    [
      maintainers: ["Graham Baradoy"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Baradoy/credo_spellchecker"}
    ]
  end
end
