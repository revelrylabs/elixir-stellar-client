defmodule StellarTest do
  use ExUnit.Case
  doctest Stellar

  test "greets the world" do
    assert Stellar.hello() == :world
  end
end
