defmodule Stellar.Operation do
  # https://github.com/stellar/js-stellar-base/tree/master/src/operations
  alias Stellar.Operation

  defstruct type: nil,
            destination: nil,
            startingBalance: nil,
            asset: nil,
            amount: nil,
            sendAsset: nil,
            sendMax: nil,
            destAsset: nil,
            destAmount: nil,
            path: [],
            line: nil,
            limit: nil,
            trustor: nil,
            assetCode: nil,
            authorize: nil,
            inflationDest: nil,
            clearFlags: nil,
            setFlags: nil,
            masterWeight: nil,
            lowThreshold: nil,
            medThreshold: nil,
            highThreshold: nil,
            homeDomain: nil,
            signer: nil,
            selling: nil,
            buying: nil,
            price: nil,
            offerId: nil,
            name: nil,
            value: nil,
            bumpTo: nil,
            sourceAccount: nil

  def account_merge(opts) do
    %Operation{
      type: "accountMerge",
      destination: Map.get(opts, :destination),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def allow_trust(opts) do
    %Operation{
      type: "allowTrust",
      trustor: Map.get(opts, :trustor),
      assetCode: Map.get(opts, :asset_code),
      authorize: Map.get(opts, :authorize),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def bump_sequence(opts) do
    %Operation{
      type: "bumpSequence",
      bumpTo: Map.get(opts, :bump_to),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def change_trust(opts) do
    %Operation{
      type: "changeTrust",
      limit: Map.get(opts, :limit, "9223372036854775807"),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def create_account(opts) do
    %Operation{
      type: "createAccount",
      destination: Map.get(opts, :destination),
      startingBalance: Map.get(opts, :starting_balance),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def create_passive_offer(opts) do
    %Operation{
      type: "createPassiveOffer",
      selling: Map.get(opts, :selling),
      buying: Map.get(opts, :buying),
      amount: Map.get(opts, :amount),
      price: Map.get(opts, :price),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def inflation(opts) do
    %Operation{
      type: "inflation",
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def manage_data(opts) do
    %Operation{
      type: "manageData",
      name: Map.get(opts, :name),
      value: Map.get(opts, :value),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def manage_offer(opts) do
    %Operation{
      type: "manageOffer",
      selling: Map.get(opts, :selling),
      buying: Map.get(opts, :buying),
      amount: Map.get(opts, :amount),
      price: Map.get(opts, :price),
      offerId: Map.get(opts, :offer_id, "0"),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def path_payment(opts) do
    %Operation{
      type: "pathPayment",
      sendAsset: Map.get(opts, :send_asset),
      sendMax: Map.get(opts, :send_max),
      destination: Map.get(opts, :destination),
      destAsset: Map.get(opts, :dest_asset),
      destAmount: Map.get(opts, :dest_amount),
      path: Map.get(opts, :path),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def payment(opts) do
    %Operation{
      type: "payment",
      destination: Map.get(opts, :destination),
      asset: Map.get(opts, :asset),
      amount: Map.get(opts, :amount),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def set_options(opts) do
    %Operation{
      type: "setOptions",
      inflationDest: Map.get(opts, :inflation_dest),
      clearFlags: Map.get(opts, :clear_flags),
      setFlags: Map.get(opts, :set_flags),
      masterWeight: Map.get(opts, :master_weight),
      lowThreshold: Map.get(opts, :low_threshold),
      medThreshold: Map.get(opts, :med_threshold),
      highThreshold: Map.get(opts, :high_threshold),
      signer: Map.get(opts, :signer),
      homeDomain: Map.get(opts, :home_domain)
    }
  end

  def to_xdr(_operation) do
    nil
  end
end
