defmodule Stellar.Operations.Test do
  use Stellar.HttpCase
  alias Stellar.Operations

  test "get operation details", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/operations/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end)

    assert {:ok, %{"id" => "123456"}} = Operations.get("123456")
  end

  test "get all operations", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/operations", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Operations.all()
  end

  test "get all operations for an account", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/accounts/123456/operations", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Operations.all_for_account("123456")
  end

  test "get all operations for a ledger", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/ledgers/123456/operations", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Operations.all_for_ledger("123456")
  end

  test "get all operations for a transaction", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/transactions/123456/operations", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Operations.all_for_transaction("123456")
  end
end
