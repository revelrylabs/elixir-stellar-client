defmodule Stellar.Transactions.Signer.Test do
  use ExUnit.Case, async: true
  alias Stellar.KeyPair
  alias Stellar.Transactions.Signer

  describe "sign" do
    test "one signature" do
      {_, secret} = KeyPair.random()
      transaction = %Stellar.XDR.Transaction{}

      signature =
        Signer.sign(
          transaction,
          secret
        )

      assert Signer.verify(signature, transaction, secret) == true
    end
  end
end
