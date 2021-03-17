defmodule Stellar.MixProject do
  use Mix.Project

  def project do
    [
      app: :stellar,
      version: "0.3.1",
      description: description(),
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

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
      {:jason, "~> 1.0"},
      {:crc, "~> 0.10.1"},
      {:ed25519, "~> 1.1"},
      {:ex_doc, "~> 0.24.0", only: :dev},
      {:bypass, "~> 2.1.0", only: :test},
      {:excoveralls, "~> 0.10.3", only: :test},
      {:xdr, "~> 0.1.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    """
    Stellar API client for Elixir
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md"],
      maintainers: ["Bryan Joseph", "Luke Ledet"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/revelrylabs/elixir-stellar-client"
      },
      build_tools: ["mix"]
    ]
  end
end
