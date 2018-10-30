defmodule Stellar.API.Trades do
  @moduledoc """
  Functions for interacting with Trades
  """
  alias Stellar.Base

  @doc """
  Returns all trades

  optional `params` can take any of the following.:

  * `base_asset_type`: Type of base asset.

  * `base_asset_code`: Code of base asset, not required if type is `native`.

  * `base_asset_issuer`: Issuer of base asset, not required if type is `native`.

  * `counter_asset_type`: Type of counter asset.

  * `counter_asset_code`: Code of counter asset, not required if type is `native`.

  * `counter_asset_issuer`: Issuer of counter asset, not required if type is `native`.

  * `offer_id`: filter for by a specific offer id.

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t()) :: {Stellar.status(), map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/trades#{query}")
  end

  @doc """
  Returns all trades for given order book

  optional `params` can take any of the following.:

  * `selling_asset_code`: Code of the Asset being sold.

  * `selling_asset_issuer`: Account ID of the issuer of the Asset being sold.

  * `buying_asset_code`: Code of the Asset being bought.

  * `buying_asset_issuer`: Account ID of the issuer of the Asset being bought.

  * `limit`: Maximum number of records to return.
  """
  @spec all_for_order_book(Stellar.asset_type(), Stellar.asset_type(), Keyword.t()) ::
          {Stellar.status(), map}
  def all_for_order_book(selling_asset_type, buying_asset_type, params \\ []) do
    params =
      params
      |> Keyword.put(:selling_asset_type, selling_asset_type)
      |> Keyword.put(:buying_asset_type, buying_asset_type)

    query = Base.process_query_params(params)
    Base.get("/order_book/trades#{query}")
  end
end
