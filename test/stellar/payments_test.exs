defmodule Stellar.Payments.Test do
  use ExUnit.Case, async: true
  alias Stellar.Payments

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

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
