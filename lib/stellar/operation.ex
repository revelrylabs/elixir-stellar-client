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
      destination: opts.destination,
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def allow_trust(opts) do
    %Operation{
      type: "allowTrust",
      trustor: opts.trustor,
      assetCode: opts.asset_code,
      authorize: opts.authorize,
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def bump_sequence(opts) do
    %Operation{
      type: "bumpSequence",
      bumpTo: opts.bump_to,
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
      destination: opts.destination,
      startingBalance: opts.starting_balance,
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def create_passive_offer(opts) do
    %Operation{
      type: "createPassiveOffer",
      selling: opts.selling,
      buying: opts.buying,
      amount: opts.amount,
      price: opts.price,
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
      name: opts.name,
      value: opts.value,
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def manage_offer(opts) do
    %Operation{
      type: "manageOffer",
      selling: opts.selling,
      buying: opts.buying,
      amount: opts.amount,
      price: opts.price,
      offerId: Map.get(opts, :offer_id, "0"),
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def path_payment(opts) do
    %Operation{
      type: "pathPayment",
      sendAsset: opts.send_asset,
      sendMax: opts.send_max,
      destination: opts.destination,
      destAsset: opts.dest_asset,
      destAmount: opts.dest_amount,
      path: opts.path,
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def payment(opts) do
    %Operation{
      type: "payment",
      destination: opts.destination,
      asset: opts.asset,
      amount: opts.amount,
      sourceAccount: Map.get(opts, :source, nil)
    }
  end

  def set_options(opts) do
    %Operation{
      type: "setOptions",
      inflationDest: opts.inflation_dest,
      clearFlags: opts.clear_flags,
      setFlags: opts.set_flags,
      masterWeight: opts.master_weight,
      lowThreshold: opts.low_threshold,
      medThreshold: opts.med_threshold,
      highThreshold: opts.high_threshold,
      signer: opts.signer,
      homeDomain: opts.home_domain
    }
  end
end
