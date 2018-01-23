defmodule Stellar do
  @moduledoc """
  Stellar Client for Elixir

  ### Setup

  Add the following to your configuration:

  ```elixir
  config :stellar, network: :public # Default is `:public`. To use test network, use `:test`
  ```
  """

  @type status :: :ok | :error
end
