defmodule Stellar.Assets do
  @moduledoc """
  Functions for interacting with Assets
  """
  alias Stellar.Base

  @doc """
  Returns all known assets in one the network

  optional `params` can take any of the following.:

  * `asset_code`: Code the asset to filter by

  * `asset_issuer`: Issuer of the Asset to filter by

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc", ordered by `asset_code` then by `asset_issuer`.

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t) :: {Stellar.status, map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/assets#{query}")
  end
end
