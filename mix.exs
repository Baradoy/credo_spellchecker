defmodule SpellCredo.MixProject do
  use Mix.Project

  def project do
    [
      app: :spell_credo,
      version: "0.1.0",
      elixir: "~> 1.10",
      deps: deps()
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
end
