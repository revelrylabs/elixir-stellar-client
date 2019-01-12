defmodule Stellar.Accounts.IntegrationTest do
  use Stellar.IntegrationCase
  alias Stellar.Accounts

  test "get account details", %{public_key: public_key} do
    assert {:ok, %{"id" => public_key}} = Accounts.get(public_key)
  end
end
