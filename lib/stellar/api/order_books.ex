defmodule Stellar.API.OrderBooks do
  @moduledoc """
  Functions for interacting with OrderBooks
  """
  alias Stellar.API.Base

  @doc """
  Returns order book details

  optional `params` can take any of the following.:

  * `selling_asset_code`: Code of the Asset being sold.

  * `selling_asset_issuer`: Account ID of the issuer of the Asset being sold.

  * `buying_asset_code`: Code of the Asset being bought.

  * `buying_asset_issuer`: Account ID of the issuer of the Asset being bought.

  * `limit`: Maximum number of records to return.
  """
  @spec get(Stellar.asset_type(), Stellar.asset_type(), Keyword.t()) :: {Stellar.status(), map}
  def get(selling_asset_type, buying_asset_type, params \\ []) do
    params =
      params
      |> Keyword.put(:selling_asset_type, selling_asset_type)
      |> Keyword.put(:buying_asset_type, buying_asset_type)

    query = Base.process_query_params(params)
    Base.get("/order_book#{query}")
  end
end
