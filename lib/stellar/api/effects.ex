defmodule Stellar.API.Effects do
  @moduledoc """
  Functions for interacting with Effects
  """
  alias Stellar.Base

  @doc """
  Returns all effects

  optional `params` can take any of the following.:

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t()) :: {Stellar.status(), map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/effects#{query}")
  end

  @doc """
  Gets effect details
  """
  @spec get(binary) :: {Stellar.status(), map}
  def get(id) do
    Base.get("/effects/#{id}")
  end

  @doc """
  Returns all effects for given account

  See `all/1` for allowed optional params
  """
  @spec all_for_account(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_account(accountId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/accounts/#{accountId}/effects#{query}")
  end

  @doc """
  Returns all effects for given operation

  See `all/1` for allowed optional params
  """
  @spec all_for_operation(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_operation(operationId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/operations/#{operationId}/effects#{query}")
  end

  @doc """
  Returns all effects for given ledger

  See `all/1` for allowed optional params
  """
  @spec all_for_ledger(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_ledger(ledgerId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/ledgers/#{ledgerId}/effects#{query}")
  end
end
