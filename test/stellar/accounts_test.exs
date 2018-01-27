defmodule Stellar.Accounts.Test do
  use ExUnit.Case, async: true
  alias Stellar.Accounts

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

  test "get account details", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end

    assert {:ok, %{"id" => "123456"}} = Accounts.get("123456")
  end

  test "get account data", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/123456/data/user-id", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"value": "MTAw"}>)
    end

    assert {:ok, %{"value" => "MTAw"}} = Accounts.get_data("123456", "user-id")
  end
end
