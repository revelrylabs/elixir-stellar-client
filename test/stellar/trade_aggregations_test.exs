defmodule Stellar.TradeAggregations.Test do
  use Stellar.HttpCase
  alias Stellar.TradeAggregations

  test "get all trade aggregrations", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/trade_aggregations", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = TradeAggregations.all(
      :native,
      :native
    )
  end
end
