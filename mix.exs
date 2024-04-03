defmodule CredoSpellchecker.MixProject do
  use Mix.Project

  @version "0.1.6"

  def project do
    [
      app: :credo_spellchecker,
      version: @version,
      elixir: "~> 1.10",
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/Baradoy/credo_spellchecker",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
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

  defp docs() do
    [
      main: "readme",
      name: "CredoSpellchecker",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/credo_spellchecker",
      source_url: "https://github.com/Baradoy/credo_spellchecker",
      extras: [
        "README.md"
      ]
    ]
  end
end
