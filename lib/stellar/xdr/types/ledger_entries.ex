defmodule Stellar.XDR.Types.LedgerEntries do
  alias XDR.Type.{
    Enum,
    FixedOpaque,
    Union,
    VariableArray,
    VariableOpaque,
    Void
  }

  alias Stellar.XDR.Types.{
    Int32,
    Int64,
    PublicKey,
    SignerKey,
    UInt32,
    UInt64
  }

  alias PublicKey, as: AccountID

  defmodule Thresholds do
    use FixedOpaque, len: 4
  end

  defmodule Ext do
    use Union,
      switch: Int32,
      cases: [
        {0, Void}
      ]
  end

  defmodule String32 do
    use VariableArray, max_len: 32, type: XDR.Type.String
  end

  defmodule String64 do
    use VariableArray, max_len: 64, type: XDR.Type.String
  end

  defmodule DataValue do
    use VariableOpaque, max_len: 64
  end

  defmodule AssetType do
    use Enum,
      ASSET_TYPE_NATIVE: 0,
      ASSET_TYPE_CREDIT_ALPHANUM4: 1,
      ASSET_TYPE_CREDIT_ALPHANUM12: 2
  end

  defmodule Asset do
    use Union,
      switch: AssetType,
      cases: [
        {0, Void},
        {1, AssetTypeCreditAlphaNum4},
        {2, AssetTypeCreditAlphaNum12}
      ]
  end

  defmodule AssetCode4 do
    use FixedOpaque, len: 4
  end

  defmodule AssetCode12 do
    use FixedOpaque, len: 12
  end

  defmodule AssetTypeCreditAlphaNum4 do
    use XDR.Type.Struct,
      assetCode: AssetCode4,
      issuer: AccountID
  end

  defmodule AssetTypeCreditAlphaNum12 do
    use XDR.Type.Struct,
      assetCode: AssetCode12,
      issuer: AccountID
  end

  defmodule Price do
    use XDR.Type.Struct,
      n: Int32,
      d: Int32
  end

  defmodule ThresholdIndexes do
    use Enum,
      THRESHOLD_MASTER_WEIGHT: 0,
      THRESHOLD_LOW: 1,
      THRESHOLD_MED: 2,
      THRESHOLD_HIGH: 3
  end

  defmodule LedgerEntryType do
    use Enum,
      ACCOUNT: 0,
      TRUSTLINE: 1,
      OFFER: 2,
      DATA: 3
  end

  defmodule Signer do
    use XDR.Type.Struct,
      key: SignerKey,
      weight: UInt32
  end

  defmodule Signers do
    use VariableArray, max_len: 20, type: Signer
  end

  defmodule AccountFlags do
    use Enum,
      AUTH_REQUIRED_FLAG: 0x1,
      AUTH_REVOCABLE_FLAG: 0x2,
      AUTH_IMMUTABLE_FLAG: 0x4
  end

  defmodule AccountEntry do
    use XDR.Type.Struct,
      accountID: AccountID,
      balance: Int64,
      seqNum: UInt64,
      numSubEntries: UInt32,
      inflationDest: AccountID,
      flags: UInt32,
      homeDomain: XDR.Type.String,
      thresholds: Thresholds,
      signers: Signers,
      ext: Ext
  end

  defmodule TrustLineFlags do
    use Enum,
      AUTHORIZED_FLAG: 1
  end

  defmodule TrustLineEntry do
    use XDR.Type.Struct,
      accountID: AccountID,
      asset: Asset,
      balance: Int64,
      limit: Int64,
      flags: UInt32,
      ext: Ext
  end

  defmodule OfferEntryFlags do
    use Enum,
      PASSIVE_FLAG: 1
  end

  defmodule OfferEntry do
    use XDR.Type.Struct,
      sellerID: AccountID,
      offerID: UInt64,
      selling: Asset,
      buying: Asset,
      amount: Int64,
      price: Price,
      flags: UInt32,
      ext: Ext
  end

  defmodule DataEntry do
    use XDR.Type.Struct,
      accountID: AccountID,
      dataName: String64,
      dataValue: DataValue,
      ext: Ext
  end

  defmodule LedgerEntryData do
    use Union,
      switch: LedgerEntryType,
      cases: [
        {0, AccountEntry},
        {1, TrustLineEntry},
        {2, OfferEntry},
        {3, DataEntry}
      ]
  end

  defmodule LedgerEntry do
    use XDR.Type.Struct,
      lastModifiedLedgerSeq: UInt32,
      data: LedgerEntryData,
      ext: Ext
  end

  defmodule EnvelopeType do
    use Enum,
      ENVELOPE_TYPE_SCP: 1,
      ENVELOPE_TYPE_TX: 2,
      ENVELOPE_TYPE_AUTH: 3
  end
end
