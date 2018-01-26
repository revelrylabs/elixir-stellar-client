# Stellar

[![Build Status](https://travis-ci.org/revelrylabs/elixir-stellar-client.svg?branch=master)](https://travis-ci.org/revelrylabs/elixir-stellar-client)

A [Stellar](https://stellar.org) client for Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `stellar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stellar, "~> 0.1.0"}
  ]
end
```

## Setup

Add the following to your configuration:

```elixir
config :stellar, network: :public # Default is `:public`. To use test network, use `:test`
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/stellar](https://hexdocs.pm/stellar).
