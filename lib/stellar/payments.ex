defmodule Stellar.Payments do
  @moduledoc """
  Functions for interacting with Payments
  """
  alias Stellar.Base

  @doc """
  Returns all payments

  optional `params` can take any of the following.:

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t) :: {Stellar.status, map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/payments#{query}")
  end

  @doc """
  Returns all payments for given account

  See `all/1` for allowed optional params
  """
  @spec all_for_account(binary, Keyword.t) :: {Stellar.status, map}
  def all_for_account(accountId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/accounts/#{accountId}/payments#{query}")
  end

  @doc """
  Returns all payments for given ledger

  See `all/1` for allowed optional params
  """
  @spec all_for_ledger(binary, Keyword.t) :: {Stellar.status, map}
  def all_for_ledger(ledgerId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/ledgers/#{ledgerId}/payments#{query}")
  end
end
