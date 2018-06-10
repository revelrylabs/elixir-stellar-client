alias XDR.Type.{
  FixedOpaque,
  Enum,
  Union,
  VariableOpaque,
  Void,
  Int,
  Uint,
  HyperInt,
  HyperUint,
  VariableArray
}

alias Stellar.XDR.SignerKey
alias Stellar.XDR.PublicKey, as: AccountID

defmodule Stellar.XDR.OptionalAccountID do
  use XDR.Type.Optional, for: AccountID
end

defmodule Stellar.XDR.Thresholds do
  use FixedOpaque, len: 4
end

defmodule Stellar.XDR.String32 do
  use VariableArray, spec: [max_len: 32, type: XDR.Type.String]
end

defmodule Stellar.XDR.String64 do
  use VariableArray, spec: [max_len: 64, type: XDR.Type.String]
end

defmodule Stellar.XDR.DataValue do
  use VariableOpaque, max_len: 64
end

defmodule Stellar.XDR.AssetType do
  use Enum,
    spec: [
      ASSET_TYPE_NATIVE: 0,
      ASSET_TYPE_CREDIT_ALPHANUM4: 1,
      ASSET_TYPE_CREDIT_ALPHANUM12: 2
    ]
end

defmodule Stellar.XDR.Asset do
  use Union,
    spec: [
      switch: Stellar.XDR.AssetType,
      cases: [
        ASSET_TYPE_NATIVE: Void,
        ASSET_TYPE_CREDIT_ALPHANUM4: Stellar.XDR.AssetTypeCreditAlphaNum4,
        ASSET_TYPE_CREDIT_ALPHANUM12: Stellar.XDR.AssetTypeCreditAlphaNum12
      ]
    ]
end

defmodule Stellar.XDR.AssetCode4 do
  use FixedOpaque, len: 4
end

defmodule Stellar.XDR.AssetCode12 do
  use FixedOpaque, len: 12
end

defmodule Stellar.XDR.AssetTypeCreditAlphaNum4 do
  use XDR.Type.Struct,
    spec: [
      assetCode: Stellar.XDR.AssetCode4,
      issuer: AccountID
    ]
end

defmodule Stellar.XDR.AssetTypeCreditAlphaNum12 do
  use XDR.Type.Struct,
    spec: [
      assetCode: Stellar.XDR.AssetCode12,
      issuer: AccountID
    ]
end

defmodule Stellar.XDR.Price do
  use XDR.Type.Struct,
    spec: [
      n: Int,
      d: Int
    ]
end

defmodule Stellar.XDR.ThresholdIndexes do
  use Enum,
    spec: [
      THRESHOLD_MASTER_WEIGHT: 0,
      THRESHOLD_LOW: 1,
      THRESHOLD_MED: 2,
      THRESHOLD_HIGH: 3
    ]
end

defmodule Stellar.XDR.LedgerEntryType do
  use Enum,
    spec: [
      ACCOUNT: 0,
      TRUSTLINE: 1,
      OFFER: 2,
      DATA: 3
    ]
end

defmodule Stellar.XDR.Signer do
  use XDR.Type.Struct,
    spec: [
      key: Stellar.XDR.SignerKey,
      weight: Uint
    ]
end

defmodule Stellar.XDR.AccountFlags do
  use Enum,
    spec: [
      AUTH_REQUIRED_FLAG: 0x1,
      AUTH_REVOCABLE_FLAG: 0x2,
      AUTH_IMMUTABLE_FLAG: 0x4
    ]
end

defmodule Stellar.XDR.AccountEntry do
  use XDR.Type.Struct,
    spec: [
      accountID: AccountID,
      balance: HyperInt,
      seqNum: HyperUint,
      numSubEntries: Uint,
      inflationDest: Stellar.XDR.OptionalAccountID,
      flags: Uint,
      homeDomain: XDR.Type.String,
      thresholds: Stellar.XDR.Thresholds,
      signers: Stellar.XDR.Signers,
      ext: Stellar.XDR.Ext
    ]

  defmodule Stellar.XDR.Signers do
    use VariableArray, spec: [max_len: 20, type: Signer]
  end
end

defmodule Stellar.XDR.Ext do
  use Union,
    spec: [
      switch: Int,
      cases: [
        {0, Void}
      ]
    ]
end

defmodule Stellar.XDR.TrustLineFlags do
  use Enum,
    spec: [
      AUTHORIZED_FLAG: 1
    ]
end

defmodule Stellar.XDR.TrustLineEntry do
  use XDR.Type.Struct,
    spec: [
      accountID: AccountID,
      asset: Asset,
      balance: HyperInt,
      limit: HyperInt,
      flags: Uint,
      ext: Stellar.XDR.Ext
    ]
end

defmodule Stellar.XDR.OfferEntryFlags do
  use Enum,
    spec: [
      PASSIVE_FLAG: 1
    ]
end

defmodule Stellar.XDR.OfferEntry do
  use XDR.Type.Struct,
    spec: [
      sellerID: AccountID,
      offerID: HyperUint,
      selling: Stellar.XDR.Asset,
      buying: Stellar.XDR.Asset,
      amount: HyperInt,
      price: Stellar.XDR.Price,
      flags: Uint,
      ext: Stellar.XDR.Ext
    ]
end

defmodule Stellar.XDR.DataEntry do
  use XDR.Type.Struct,
    spec: [
      accountID: AccountID,
      dataName: Stellar.XDR.String64,
      dataValue: Stellar.XDR.DataValue,
      ext: Stellar.XDR.Ext
    ]
end

defmodule Stellar.XDR.LedgerEntry do
  use XDR.Type.Struct,
    spec: [
      lastModifiedLedgerSeq: Uint,
      data: Stellar.XDR.Data,
      ext: Stellar.XDR.Ext
    ]

  defmodule Stellar.XDR.Data do
    use Union,
      spec: [
        switch: Stellar.XDR.LedgerEntryType,
        cases: [
          ACCOUNT: Stellar.XDR.AccountEntry,
          TRUSTLINE: Stellar.XDR.TrustLineEntry,
          OFFER: Stellar.XDR.OfferEntry,
          DATA: Stellar.XDR.DataEntry
        ]
      ]
  end
end

defmodule Stellar.XDR.EnvelopeType do
  use Enum,
    spec: [
      ENVELOPE_TYPE_SCP: 1,
      ENVELOPE_TYPE_TX: 2,
      ENVELOPE_TYPE_AUTH: 3
    ]
end
