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
  @type asset_type :: :native | :credit_alphanum4 | :credit_alphanum12

  @doc """
  Shows the url to the cconfigured network
  """
  def network do
    Stellar.Base.get_url()
  end
end
