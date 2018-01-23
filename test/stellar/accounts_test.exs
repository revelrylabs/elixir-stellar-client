defmodule Stellar.Accounts.Test do
  use ExUnit.Case, async: true

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

  test "Handles error response", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/unknown_id", fn conn ->
      Plug.Conn.resp(conn, 404, ~s<{"status": 404, "type": "https://stellar.org/horizon-errors/not_found", "title": "Resource Missing"}>)
    end

    assert {:error, %{"status" => 404}} = Stellar.Accounts.get("unknown_id")
  end

  test "get account detail", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end

    assert {:ok, %{"id" => "123456"}} = Stellar.Accounts.get("123456")
  end
end
