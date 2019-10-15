defmodule Stellar.FeeStats.Test do
  use Stellar.HttpCase
  alias Stellar.FeeStats

  test "get fee_stats", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/fee_stats", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"last_ledger": "22606298"}>)
    end)

    assert {:ok, %{"last_ledger" => _}} = FeeStats.get()
  end
end
