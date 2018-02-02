defmodule Stellar.Ledgers do
  @moduledoc """
  Functions for interacting with Ledgers
  """
  alias Stellar.Base

  @doc """
  Returns all ledgers

  optional `params` can take any of the following.:

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t()) :: {Stellar.status(), map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/ledgers#{query}")
  end

  @doc """
  Gets ledger details
  """
  @spec get(binary) :: {Stellar.status(), map}
  def get(id) do
    Base.get("/ledgers/#{id}")
  end
end
