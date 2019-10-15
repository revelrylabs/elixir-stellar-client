defmodule Stellar.Metrics.Test do
  use Stellar.HttpCase
  alias Stellar.Metrics

  test "get metrics", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/metrics", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"goroutines": {"value": 3193}}>)
    end)

    assert {:ok, %{"goroutines" => _}} = Metrics.get()
  end
end
