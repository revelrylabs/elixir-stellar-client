defmodule Stellar.MixProject do
  use Mix.Project

  def project do
    [
      app: :stellar,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Stellar",
      source_url: "https://github.com/revelrylabs/elixir-stellar-client",
      homepage_url: "https://github.com/revelrylabs/elixir-stellar-client",
      # The main page in the docs
      docs: [main: "Stellar", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.0-rc"},
      {:ed25519, "~> 1.1"},
      {:ex_doc, "~> 0.18.1", only: :dev},
      {:bypass, "~> 0.8.1", only: :test}
    ]
  end
end
