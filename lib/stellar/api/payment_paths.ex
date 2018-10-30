defmodule Stellar.API.PaymentPaths do
  @moduledoc """
  Functions for interacting with PaymentPaths
  """
  alias Stellar.Base

  @doc """
  Returns payment paths meeting the given parameters

  optional `params` can take any of the following:

  * `destination_asset_code`: The code for the destination. Required if destination_asset_type is not `native`.

  * `destination_asset_issuer`: The issuer for the destination, Required if destination_asset_type is not `native`.

  * `source_account`: The sender’s account id. Any returned path must use a source that the sender can hold.
  """
  @spec all(binary, Stellar.asset_type(), number, Keyword.t()) :: {Stellar.status(), map}
  def all(destination_account, destination_asset_type, destination_amount, params \\ []) do
    params =
      params
      |> Keyword.put(:destination_account, destination_account)
      |> Keyword.put(:destination_amount, destination_amount)
      |> Keyword.put(:destination_asset_type, destination_asset_type)

    query = Base.process_query_params(params)
    Base.get("/paths#{query}")
  end
end
