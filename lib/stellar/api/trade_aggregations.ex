defmodule Stellar.API.TradeAggregations do
  @moduledoc """
  Functions for interacting with TradeAggregations
  """
  alias Stellar.API.Base

  @doc """
  Returns trade aggregations meeting the given parameters

  optional `params` can take any of the following:

  * `start_time`: lower time boundary represented as millis since epoch.

  * `end_time`: upper time boundary represented as millis since epoch

  * `resolution`: segment duration as millis since epoch. Supported values are 5 minutes (300000), 15 minutes (900000), 1 hour (3600000), 1 day (86400000) and 1 week (604800000).

  * `base_asset_code`: Code of base asset, not required if type is `native`

  * `base_asset_issuer`: Issuer of base asset, not required if type is `native`

  * `counter_asset_code`: Code of counter asset, not required if type is `native`

  * `counter_asset_issuer`: Issuer of counter asset, not required if type is `native`

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Stellar.asset_type(), Stellar.asset_type(), Keyword.t()) :: {Stellar.status(), map}
  def all(base_asset_type, counter_asset_type, params \\ []) do
    params =
      params
      |> Keyword.put(:base_asset_type, base_asset_type)
      |> Keyword.put(:counter_asset_type, counter_asset_type)

    query = Base.process_query_params(params)
    Base.get("/trade_aggregations#{query}")
  end
end
