defmodule Stellar.Payments.Test do
  use Stellar.HttpCase
  alias Stellar.Payments

  test "get all payments", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/payments", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Payments.all()
  end

  test "get all payments for an account", %{bypass: bypass} do
    Bypass.expect_once bypass, "GET", "/accounts/123456/payments", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end

    assert {:ok, %{"_embedded" => _}} = Payments.all_for_account("123456")
  end
end
