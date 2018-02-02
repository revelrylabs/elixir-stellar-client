defmodule Stellar.PaymentPaths.Test do
  use Stellar.HttpCase
  alias Stellar.PaymentPaths

  test "get all payment paths", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/paths", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} =
             PaymentPaths.all(
               "GAEDTJ4PPEFVW5XV2S7LUXBEHNQMX5Q2GM562RJGOQG7GVCE5H3HIB4V",
               20.1,
               :native
             )
  end
end
