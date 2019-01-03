defmodule Stellar.API.Operations do
  @moduledoc """
  Functions for interacting with Operations
  """
  alias Stellar.API.Base

  @doc """
  Returns all operations

  optional `params` can take any of the following.:

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t()) :: {Stellar.status(), map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/operations#{query}")
  end

  @doc """
  Gets operation details
  """
  @spec get(binary) :: {Stellar.status(), map}
  def get(id) do
    Base.get("/operations/#{id}")
  end

  @doc """
  Returns all operations for given account

  See `all/1` for allowed optional params
  """
  @spec all_for_account(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_account(accountId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/accounts/#{accountId}/operations#{query}")
  end

  @doc """
  Returns all operations for given ledger

  See `all/1` for allowed optional params
  """
  @spec all_for_ledger(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_ledger(ledgerId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/ledgers/#{ledgerId}/operations#{query}")
  end
end
