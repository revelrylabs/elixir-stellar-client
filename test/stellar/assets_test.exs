defmodule Stellar.Assets.Test do
  use Stellar.HttpCase
  alias Stellar.Assets

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
