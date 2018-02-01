defmodule Stellar.OrderBooks.Test do
  use Stellar.HttpCase
  alias Stellar.OrderBooks

  test "get order book details", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/order_book", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"bids": []}>)
    end

    assert {:ok, %{"bids" => []}} = OrderBooks.get(:native, :native)
  end
end
