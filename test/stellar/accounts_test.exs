defmodule Stellar.Accounts.Test do
  use ExUnit.Case, async: true
  alias Stellar.Accounts

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

  test "get account detail", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end

    assert {:ok, %{"id" => "123456"}} = Accounts.get("123456")
  end
end
