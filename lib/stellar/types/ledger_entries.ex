defmodule Stellar.Types.LedgerEntries do
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

  alias Stellar.Types.{PublicKey, SignerKey}

  defmodule Thresholds do
    use FixedOpaque, len: 4
  end

  defmodule String32 do
    use VariableArray, spec: [max_len: 32, type: XDR.Type.String]
  end

  defmodule String64 do
    use VariableArray, spec: [max_len: 64, type: XDR.Type.String]
  end

  defmodule DataValue do
    use VariableOpaque, max_len: 64
  end

  defmodule AssetType do
    use Enum,
      spec: [
        ASSET_TYPE_NATIVE: 0,
        ASSET_TYPE_CREDIT_ALPHANUM4: 1,
        ASSET_TYPE_CREDIT_ALPHANUM12: 2
      ]
  end

  defmodule Asset do
    use Union,
      spec: [
        switch: AssetType,
        cases: [
          {0, Void},
          {1, AssetTypeCreditAlphaNum4},
          {2, AssetTypeCreditAlphaNum12}
        ]
      ]
  end

  defmodule AssetTypeCreditAlphaNum4 do
    use XDR.Type.Struct,
      spec: [
        assetCode: AssetCode,
        issuer: PublicKey
      ]

    defmodule AssetCode do
      use FixedOpaque, len: 4
    end
  end

  defmodule AssetTypeCreditAlphaNum12 do
    use XDR.Type.Struct,
      spec: [
        assetCode: AssetCode,
        issuer: PublicKey
      ]

    defmodule AssetCode do
      use FixedOpaque, len: 12
    end
  end

  defmodule Price do
    use XDR.Type.Struct,
      spec: [
        n: Int,
        d: Int
      ]
  end

  defmodule ThresholdIndexes do
    use Enum,
      spec: [
        THRESHOLD_MASTER_WEIGHT: 0,
        THRESHOLD_LOW: 1,
        THRESHOLD_MED: 2,
        THRESHOLD_HIGH: 3
      ]
  end

  defmodule LedgerEntryType do
    use Enum,
      spec: [
        ACCOUNT: 0,
        TRUSTLINE: 1,
        OFFER: 2,
        DATA: 3
      ]
  end

  defmodule Signer do
    use XDR.Type.Struct,
      spec: [
        key: SignerKey,
        weight: Uint
      ]
  end

  defmodule AccountFlags do
    use Enum,
      spec: [
        AUTH_REQUIRED_FLAG: 0x1,
        AUTH_REVOCABLE_FLAG: 0x2,
        AUTH_IMMUTABLE_FLAG: 0x4
      ]
  end

  defmodule AccountEntry do
    use XDR.Type.Struct,
      spec: [
        accountID: PublicKey,
        balance: HyperInt,
        seqNum: HyperUint,
        numSubEntries: Uint,
        inflationDest: PublicKey,
        flags: Uint,
        homeDomain: XDR.Type.String,
        thresholds: Thresholds,
        signers: Signers,
        ext: Ext
      ]

    defmodule Signers do
      use VariableArray, spec: [max_len: 20, type: Signer]
    end
  end

  defmodule Ext do
    use Union,
      spec: [
        switch: Int,
        cases: [
          {0, Void}
        ]
      ]
  end

  defmodule TrustLineFlags do
    use Enum,
      spec: [
        AUTHORIZED_FLAG: 1
      ]
  end

  defmodule TrustLineEntry do
    use XDR.Type.Struct,
      spec: [
        accountID: PublicKey,
        asset: Asset,
        balance: HyperInt,
        limit: HyperInt,
        flags: Uint,
        ext: Ext
      ]
  end

  defmodule OfferEntryFlags do
    use Enum,
      spec: [
        PASSIVE_FLAG: 1
      ]
  end

  defmodule OfferEntry do
    use XDR.Type.Struct,
      spec: [
        sellerID: PublicKey,
        offerID: HyperUint,
        selling: Asset,
        buying: Asset,
        amount: HyperInt,
        price: Price,
        flags: Uint,
        ext: Ext
      ]
  end

  defmodule DataEntry do
    use XDR.Type.Struct,
      spec: [
        accountID: PublicKey,
        dataName: String64,
        dataValue: DataValue,
        ext: Ext
      ]
  end

  defmodule LedgerEntry do
    use XDR.Type.Struct,
      spec: [
        lastModifiedLedgerSeq: Uint,
        data: Data,
        ext: Ext
      ]

    defmodule Data do
      use Union,
        spec: [
          switch: LedgerEntryType,
          cases: [
            {0, AccountEntry},
            {1, TrustLineEntry},
            {2, OfferEntry},
            {3, DataEntry}
          ]
        ]
    end
  end

  defmodule EnvelopeType do
    use Enum,
      spec: [
        ENVELOPE_TYPE_SCP: 1,
        ENVELOPE_TYPE_TX: 2,
        ENVELOPE_TYPE_AUTH: 3
      ]
  end
end
