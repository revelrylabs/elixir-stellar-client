defmodule StellarTest do
  use ExUnit.Case, async: true
  doctest Stellar

  test "shows configured network" do
    Application.put_env(:stellar, :network, :test)
    assert Stellar.network() =~ "testnet"
  end
end
