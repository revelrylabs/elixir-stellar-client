defmodule Stellar.API.Accounts do
  @moduledoc """
  Functions for interacting with Accounts
  """
  alias Stellar.API.Base

  @doc """
  Gets account details
  """
  @spec get(binary) :: {Stellar.status(), map}
  def get(accountId) do
    Base.get("/accounts/#{accountId}")
  end

  @doc """
  Gets a single data associated with the given account
  """
  @spec get_data(binary, binary) :: {Stellar.status(), map}
  def get_data(accountId, key) do
    Base.get("/accounts/#{accountId}/data/#{key}")
  end
end
