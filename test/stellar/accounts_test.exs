defmodule Stellar.Accounts.Test do
  use Stellar.HttpCase
  alias Stellar.Accounts

  test "get account details", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/accounts/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end)

    assert {:ok, %{"id" => "123456"}} = Accounts.get("123456")
  end

  test "get account data", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/accounts/123456/data/user-id", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"value": "MTAw"}>)
    end)

    assert {:ok, %{"value" => "MTAw"}} = Accounts.get_data("123456", "user-id")
  end
end
