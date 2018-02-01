defmodule Stellar.Ledgers.Test do
  use Stellar.HttpCase
  alias Stellar.Ledgers

  test "get ledger details", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/ledgers/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end

    assert {:ok, %{"id" => "123456"}} = Ledgers.get("123456")
  end

  test "get all ledgers", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/ledgers", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Ledgers.all()
  end
end
