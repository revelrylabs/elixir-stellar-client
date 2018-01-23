defmodule Stellar.Accounts do
  @moduledoc """
  Functions for interacting with Accounts
  """
  alias Stellar.Base

  @doc """
  Gets account details
  """
  @spec get(binary) :: {Stellar.status, map}
  def get(accountId) do
    Base.get("/accounts/#{accountId}")
  end
end
