defmodule Stellar.Offers do
  @moduledoc """
  Functions for interacting with Offers
  """
  alias Stellar.Base

  @doc """
  Returns all offers for given account

  optional `params` can take any of the following.:

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all_for_account(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_account(accountId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/accounts/#{accountId}/offers#{query}")
  end
end
