defmodule Stellar.KeyPair.Test do
  use ExUnit.Case, async: true
  alias Stellar.KeyPair

  # testing example from https://www.stellar.org/developers/js-stellar-base/reference/building-transactions.html#class
  test "example works" do
    secret = "SBK2VIYYSVG76E7VC3QHYARNFLY2EAQXDHRC7BMXBBGIFG74ARPRMNQM"
    {public_key, ^secret} = KeyPair.from_secret("SBK2VIYYSVG76E7VC3QHYARNFLY2EAQXDHRC7BMXBBGIFG74ARPRMNQM")
    assert public_key == "GDHMW6QZOL73SHKG2JA3YHXFDHM46SS5ZRWEYF5BCYHX2C5TVO6KZBYL"
  end

  test "random" do
    assert {_public_key, _secret} = KeyPair.random()
  end
end
