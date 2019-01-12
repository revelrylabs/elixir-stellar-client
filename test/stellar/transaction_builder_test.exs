defmodule Stellar.TransactionBuilder.Test do
  use ExUnit.Case
  alias Stellar.{Accounts, TransactionBuilder, Operation, Asset, Memo}

  test "build" do
    memo = Memo.text("Happy Birthday")

    account = Accounts.get("GAR4PWZ4FIVR6XFQLVW2AKDRW46HQV5SXTAEHXCKIJVITHBHWS76OV2P")

    transaction =
      account
      |> TransactionBuilder.new(memo: memo)
      |> TransactionBuilder.add_operation(
        Operation.payment(%{
          destination: "GASOCNHNNLYFNMDJYQ3XFMI7BYHIOCFW3GJEOWRPEGK2TDPGTG2E5EDW",
          asset: Asset.native(),
          amount: "100.50"
        })
      )
      |> TransactionBuilder.add_operation(
        Operation.set_options(%{
          signer: %{
            ed25519PublicKey: "",
            weight: 1
          }
        })
      )
      |> TransactionBuilder.build()
  end
end
