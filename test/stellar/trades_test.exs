defmodule Stellar.Trades.Test do
  use Stellar.HttpCase
  alias Stellar.Trades

  test "get all trades", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/trades", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Trades.all()
  end

  test "get all trades for an order book", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/order_book/trades", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Trades.all_for_order_book(:native, :native)
  end
end
