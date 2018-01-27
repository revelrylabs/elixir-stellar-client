defmodule Stellar.Assets.Test do
  use ExUnit.Case, async: true
  alias Stellar.Assets

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

  test "get assets with no parameters", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/assets", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Assets.all()
  end

  test "get assets with parameters", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/assets", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Assets.all(
      asset_code: "USD",
      order: "desc"
    )
  end
end
