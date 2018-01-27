defmodule Stellar.Effects.Test do
  use ExUnit.Case, async: true
  alias Stellar.Effects

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

  test "get effect details", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/effects/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end

    assert {:ok, %{"id" => "123456"}} = Effects.get("123456")
  end

  test "get all effects", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/effects", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Effects.all()
  end

  test "get all effects for an account", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/123456/effects", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Effects.all_for_account("123456")
  end
end
