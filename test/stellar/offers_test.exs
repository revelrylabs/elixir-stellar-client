defmodule Stellar.Offers.Test do
  use Stellar.HttpCase
  alias Stellar.Offers

  test "get all offers for an account", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/accounts/123456/offers", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Offers.all_for_account("123456")
  end
end
