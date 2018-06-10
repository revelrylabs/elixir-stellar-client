alias XDR.Type.{
  Enum,
  Union,
  Void,
  Int,
  Uint,
  HyperInt,
  HyperUint,
  VariableArray,
  Uint
}

alias Stellar.XDR.{SignatureHint, Signature, Hash}
alias Stellar.XDR.PublicKey, as: AccountID

alias Stellar.XDR.{
  Asset,
  Price,
  String32,
  Signer,
  AssetCode4,
  AssetCode12,
  String64,
  DataValue,
  Ext,
  OfferEntry,
  AssetType,
  OptionalAccountID
}

defmodule Stellar.XDR.DecoratedSignature do
  use XDR.Type.Struct,
    spec: [
      hint: SignatureHint,
      signature: Signature
    ]
end

defmodule Stellar.XDR.OperationType do
  use Enum,
    spec: [
      CREATE_ACCOUNT: 0,
      PAYMENT: 1,
      PATH_PAYMENT: 2,
      MANAGE_OFFER: 3,
      CREATE_PASSIVE_OFFER: 4,
      SET_OPTIONS: 5,
      CHANGE_TRUST: 6,
      ALLOW_TRUST: 7,
      ACCOUNT_MERGE: 8,
      INFLATION: 9,
      MANAGE_DATA: 10
    ]
end

defmodule Stellar.XDR.CreateAccountOp do
  use XDR.Type.Struct,
    spec: [
      destination: AccountID,
      startingBalance: HyperInt
    ]
end

defmodule Stellar.XDR.PaymentOp do
  use XDR.Type.Struct,
    spec: [
      destination: AccountID,
      asset: Asset,
      amount: HyperInt
    ]
end

defmodule Stellar.XDR.AssetPaths do
  use VariableArray, spec: [max_len: 5, type: Asset]
end

defmodule Stellar.XDR.PathPaymentOp do
  use XDR.Type.Struct,
    spec: [
      sendAsset: Asset,
      sendMax: HyperInt,
      destination: AccountID,
      destinationAsset: Asset,
      destinationAmount: HyperInt,
      path: Stellar.XDR.AssetPaths
    ]
end

defmodule Stellar.XDR.ManageOfferOp do
  use XDR.Type.Struct,
    spec: [
      selling: Asset,
      buying: Asset,
      amount: HyperInt,
      price: Price,
      offerID: HyperUint
    ]
end

defmodule Stellar.XDR.CreatePassiveOfferOp do
  use XDR.Type.Struct,
    spec: [
      selling: Asset,
      buying: Asset,
      amount: HyperInt,
      price: Price
    ]
end

defmodule Stellar.XDR.OptionalUint do
  use XDR.Type.Optional, for: Uint
end

defmodule Stellar.XDR.OptionalString32 do
  use XDR.Type.Optional, for: String32
end

defmodule Stellar.XDR.OptionalSigner do
  use XDR.Type.Optional, for: Signer
end

defmodule Stellar.XDR.SetOptionsOp do
  use XDR.Type.Struct,
    spec: [
      inflationDest: AccountID,
      clearFlags: Stellar.XDR.OptionalUint,
      setFlags: Stellar.XDR.OptionalUint,
      masterWeight: Stellar.XDR.OptionalUint,
      lowThreshold: Stellar.XDR.OptionalUint,
      medThreshold: Stellar.XDR.OptionalUint,
      highThreshold: Stellar.XDR.OptionalUint,
      homeDomain: Stellar.XDR.OptionalString32,
      signer: Stellar.XDR.OptionalSigner
    ]
end

defmodule Stellar.XDR.ChangeTrustOp do
  use XDR.Type.Struct,
    spec: [
      line: Asset,
      limit: HyperInt
    ]
end

defmodule Stellar.XDR.AllowTrustOp do
  use XDR.Type.Struct,
    spec: [
      trustor: AccountID,
      asset: Asset
    ]

  defmodule Asset do
    use Union,
      spec: [
        switch: AssetType,
        cases: [
          ASSET_TYPE_CREDIT_ALPHANUM4: AssetCode4,
          ASSET_TYPE_CREDIT_ALPHANUM12: AssetCode12
        ]
      ]
  end
end

defmodule Stellar.XDR.ManageDataOp do
  use XDR.Type.Struct,
    spec: [
      dataName: Stellar.XDR.String64,
      dataValue: Stellar.XDR.DataValue
    ]
end

defmodule Stellar.XDR.Operation do
  use XDR.Type.Struct,
    spec: [
      sourceAccount: OptionalAccountID,
      body: OperationUnion
    ]

  defmodule OperationUnion do
    use Union,
      spec: [
        switch: Stellar.XDR.OperationType,
        cases: [
          CREATE_ACCOUNT: Stellar.XDR.CreateAccountOp,
          PAYMENT: Stellar.XDR.PaymentOp,
          PATH_PAYMENT: Stellar.XDR.PathPaymentOp,
          MANAGE_OFFER: Stellar.XDR.ManageOfferOp,
          CREATE_PASSIVE_OFFER: Stellar.XDR.CreatePassiveOfferOp,
          SET_OPTIONS: Stellar.XDR.SetOptionsOp,
          CHANGE_TRUST: Stellar.XDR.ChangeTrustOp,
          ALLOW_TRUST: Stellar.XDR.AllowTrustOp,
          ACCOUNT_MERGE: AccountID,
          INFLATION: Void,
          MANAGE_DATA: Stellar.XDR.ManageDataOp
        ]
      ]
  end
end

defmodule Stellar.XDR.MemoType do
  use Enum,
    spec: [
      MEMO_NONE: 0,
      MEMO_TEXT: 1,
      MEMO_ID: 2,
      MEMO_HASH: 3,
      MEMO_RETURN: 4
    ]
end

defmodule Stellar.XDR.Text do
  use VariableArray, spec: [max_len: 28, type: XDR.Type.String]
end

defmodule Stellar.XDR.Memo do
  use Union,
    spec: [
      switch: Stellar.XDR.MemoType,
      cases: [
        MEMO_NONE: Void,
        MEMO_TEXT: Stellar.XDR.Text,
        MEMO_ID: HyperUint,
        MEMO_HASH: Stellar.XDR.Hash,
        MEMO_RETURN: Stellar.XDR.Hash
      ]
    ]
end

defmodule Stellar.XDR.TimeBounds do
  use XDR.Type.Struct,
    spec: [
      minTime: HyperUint,
      maxTime: HyperUint
    ]
end

defmodule Stellar.XDR.OptionalTimeBounds do
  use XDR.Type.Optional, for: Stellar.XDR.TimeBounds
end

defmodule Stellar.XDR.Transaction do
  use XDR.Type.Struct,
    spec: [
      sourceAccount: AccountID,
      fee: Int,
      seqNum: HyperUint,
      timeBounds: Stellar.XDR.OptionalTimeBounds,
      memo: Stellar.XDR.Memo,
      operations: Stellar.XDR.Operations,
      ext: Stellar.XDR.Ext
    ]

  defmodule Operations do
    use VariableArray, spec: [max_len: 100, type: Stellar.XDR.Operation]
  end
end

defmodule Stellar.XDR.TransactionSignaturePayload do
  use XDR.Type.Struct,
    spec: [
      networkId: Stellar.XDR.Hash,
      taggedTransaction: TaggedTransaction
    ]

  defmodule TaggedTransaction do
    use Union,
      spec: [
        switch: Stellar.XDR.EnvelopeType,
        cases: [
          ENVELOPE_TYPE_TX: Stellar.XDR.Transaction
        ]
      ]
  end
end

defmodule Stellar.XDR.DecoratedSignatures do
  use VariableArray, spec: [max_len: 20, type: Stellar.XDR.DecoratedSignature]
end

defmodule Stellar.XDR.TransactionEnvelope do
  use XDR.Type.Struct,
    spec: [
      tx: Stellar.XDR.Transaction,
      signatures: Stellar.XDR.DecoratedSignatures
    ]
end

defmodule Stellar.XDR.ClaimOfferAtom do
  use XDR.Type.Struct,
    spec: [
      sellerID: AccountID,
      offerID: HyperUint,
      assetSold: Asset,
      amountSold: HyperInt,
      assetBought: Asset,
      amountBought: HyperInt
    ]
end

defmodule Stellar.XDR.CreateAccountResultCode do
  use Enum,
    spec: [
      CREATE_ACCOUNT_SUCCESS: 0,
      CREATE_ACCOUNT_MALFORMED: -1,
      CREATE_ACCOUNT_UNDERFUNDED: -2,
      CREATE_ACCOUNT_LOW_RESERVE: -3,
      CREATE_ACCOUNT_ALREADY_EXIST: -4
    ]
end

defmodule Stellar.XDR.CreateAccountResult do
  use Union,
    spec: [
      switch: Stellar.XDR.CreateAccountResultCode,
      cases: [
        CREATE_ACCOUNT_SUCCESS: Void
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.PaymentResultCode do
  use Enum,
    spec: [
      PAYMENT_SUCCESS: 0,
      PAYMENT_MALFORMED: -1,
      PAYMENT_UNDERFUNDED: -2,
      PAYMENT_SRC_NO_TRUST: -3,
      PAYMENT_SRC_NOT_AUTHORIZED: -4,
      PAYMENT_NO_DESTINATION: -5,
      PAYMENT_NO_TRUST: -6,
      PAYMENT_NOT_AUTHORIZED: -7,
      PAYMENT_LINE_FULL: -8,
      PAYMENT_NO_ISSUER: -9
    ]
end

defmodule Stellar.XDR.PaymentResult do
  use Union,
    spec: [
      switch: Stellar.XDR.PaymentResultCode,
      cases: [
        PAYMENT_SUCCESS: Void
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.PathPaymentResultCode do
  use Enum,
    spec: [
      PATH_PAYMENT_SUCCESS: 0,
      PATH_PAYMENT_MALFORMED: -1,
      PATH_PAYMENT_UNDERFUNDED: -2,
      PATH_PAYMENT_SRC_NO_TRUST: -3,
      PATH_PAYMENT_SRC_NOT_AUTHORIZED: -4,
      PATH_PAYMENT_NO_DESTINATION: -5,
      PATH_PAYMENT_NO_TRUST: -6,
      PATH_PAYMENT_NOT_AUTHORIZED: -7,
      PATH_PAYMENT_LINE_FULL: -8,
      PATH_PAYMENT_NO_ISSUER: -9,
      PATH_PAYMENT_TOO_FEW_OFFERS: -10,
      PATH_PAYMENT_OFFER_CROSS_SELF: -11,
      PATH_PAYMENT_OVER_SENDMAX: -12
    ]
end

defmodule Stellar.XDR.SimplePaymentResult do
  use XDR.Type.Struct,
    spec: [
      destination: AccountID,
      asset: Asset,
      amount: HyperInt
    ]
end

defmodule Stellar.XDR.PathPaymentResult do
  use Union,
    spec: [
      switch: Stellar.XDR.PathPaymentResultCode,
      cases: [
        PATH_PAYMENT_SUCCESS: Stellar.XDR.PaymentSuccess,
        PATH_PAYMENT_NO_ISSUER: Asset
      ],
      default: Void
    ]

  defmodule Stellar.XDR.PaymentSuccess do
    use XDR.Type.Struct,
      spec: [
        offers: ClaimOfferAtoms,
        last: Stellar.XDR.SimplePaymentResult
      ]

    defmodule ClaimOfferAtoms do
      use VariableArray, spec: [type: ClaimOfferAtom]
    end
  end
end

defmodule Stellar.XDR.ManageOfferResultCode do
  use Enum,
    spec: [
      MANAGE_OFFER_SUCCESS: 0,
      MANAGE_OFFER_MALFORMED: -1,
      MANAGE_OFFER_SELL_NO_TRUST: -2,
      MANAGE_OFFER_BUY_NO_TRUST: -3,
      MANAGE_OFFER_SELL_NOT_AUTHORIZED: -4,
      MANAGE_OFFER_BUY_NOT_AUTHORIZED: -5,
      MANAGE_OFFER_LINE_FULL: -6,
      MANAGE_OFFER_UNDERFUNDED: -7,
      MANAGE_OFFER_CROSS_SELF: -8,
      MANAGE_OFFER_SELL_NO_ISSUER: -9,
      MANAGE_OFFER_BUY_NO_ISSUER: -10,
      MANAGE_OFFER_NOT_FOUND: -11,
      MANAGE_OFFER_LOW_RESERVE: -12
    ]
end

defmodule Stellar.XDR.ManageOfferEffect do
  use Enum,
    spec: [
      MANAGE_OFFER_CREATED: 0,
      MANAGE_OFFER_UPDATED: 1,
      MANAGE_OFFER_DELETED: 2
    ]
end

defmodule Stellar.XDR.ClaimOfferAtoms do
  use VariableArray, spec: [type: Stellar.XDR.ClaimOfferAtom]
end

defmodule Stellar.XDR.ManageOfferSuccessResult do
  use XDR.Type.Struct,
    spec: [
      offersClaimed: Stellar.XDR.ClaimOfferAtoms,
      offer: OfferUnion
    ]

  defmodule OfferUnion do
    use Union,
      spec: [
        switch: ManageOfferEffect,
        cases: [
          MANAGE_OFFER_CREATED: OfferEntry,
          MANAGE_OFFER_UPDATED: OfferEntry
        ],
        default: Void
      ]
  end
end

defmodule Stellar.XDR.ManageOfferResult do
  use Union,
    spec: [
      switch: Stellar.XDR.ManageOfferResultCode,
      cases: [
        MANAGE_OFFER_SUCCESS: Stellar.XDR.ManageOfferSuccessResult
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.SetOptionsResultCode do
  use Enum,
    spec: [
      SET_OPTIONS_SUCCESS: 0,
      SET_OPTIONS_LOW_RESERVE: -1,
      SET_OPTIONS_TOO_MANY_SIGNERS: -2,
      SET_OPTIONS_BAD_FLAGS: -3,
      SET_OPTIONS_INVALID_INFLATION: -4,
      SET_OPTIONS_CANT_CHANGE: -5,
      SET_OPTIONS_UNKNOWN_FLAG: -6,
      SET_OPTIONS_THRESHOLD_OUT_OF_RANGE: -7,
      SET_OPTIONS_BAD_SIGNER: -8,
      SET_OPTIONS_INVALID_HOME_DOMAIN: -9
    ]
end

defmodule Stellar.XDR.SetOptionsResult do
  use Union,
    spec: [
      switch: Stellar.XDR.SetOptionsResultCode,
      cases: [
        SET_OPTIONS_SUCCESS: Void
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.ChangeTrustResultCode do
  use Enum,
    spec: [
      CHANGE_TRUST_SUCCESS: 0,
      CHANGE_TRUST_MALFORMED: -1,
      CHANGE_TRUST_NO_ISSUER: -2,
      CHANGE_TRUST_INVALID_LIMIT: -3,
      CHANGE_TRUST_LOW_RESERVE: -4,
      CHANGE_TRUST_SELF_NOT_ALLOWED: -5
    ]
end

defmodule Stellar.XDR.ChangeTrustResult do
  use Union,
    spec: [
      switch: Stellar.XDR.ChangeTrustResultCode,
      cases: [
        CHANGE_TRUST_SUCCESS: Void
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.AllowTrustResultCode do
  use Enum,
    spec: [
      ALLOW_TRUST_SUCCESS: 0,
      ALLOW_TRUST_MALFORMED: -1,
      ALLOW_TRUST_NO_TRUST_LINE: -2,
      ALLOW_TRUST_TRUST_NOT_REQUIRED: -3,
      ALLOW_TRUST_CANT_REVOKE: -4,
      ALLOW_TRUST_SELF_NOT_ALLOWED: -5
    ]
end

defmodule Stellar.XDR.AllowTrustResult do
  use Union,
    spec: [
      switch: Stellar.XDR.AllowTrustResultCode,
      cases: [
        ALLOW_TRUST_SUCCESS: Void
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.AccountMergeResultCode do
  use Enum,
    spec: [
      ACCOUNT_MERGE_SUCCESS: 0,
      ACCOUNT_MERGE_MALFORMED: -1,
      ACCOUNT_MERGE_NO_ACCOUNT: -2,
      ACCOUNT_MERGE_IMMUTABLE_SET: -3,
      ACCOUNT_MERGE_HAS_SUB_ENTRIES: -4
    ]
end

defmodule Stellar.XDR.AccountMergeResult do
  use Union,
    spec: [
      switch: Stellar.XDR.AccountMergeResultCode,
      cases: [
        ACCOUNT_MERGE_SUCCESS: HyperInt
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.InflationResultCode do
  use Enum,
    spec: [
      INFLATION_SUCCESS: 0,
      INFLATION_NOT_TIME: -1
    ]
end

defmodule Stellar.XDR.InflationPayout do
  use XDR.Type.Struct,
    spec: [
      destination: AccountID,
      amount: HyperInt
    ]
end

defmodule Stellar.XDR.InflationResult do
  use Union,
    spec: [
      switch: Stellar.XDR.InflationResultCode,
      cases: [
        INFLATION_SUCCESS: Payouts
      ],
      default: Void
    ]

  defmodule Payouts do
    use VariableArray, spec: [type: InflationPayout]
  end
end

defmodule Stellar.XDR.ManageDataResultCode do
  use Enum,
    spec: [
      MANAGE_DATA_SUCCESS: 0,
      MANAGE_DATA_NOT_SUPPORTED_YET: -1,
      MANAGE_DATA_NAME_NOT_FOUND: -2,
      MANAGE_DATA_LOW_RESERVE: -3,
      MANAGE_DATA_INVALID_NAME: -4
    ]
end

defmodule Stellar.XDR.ManageDataResult do
  use Union,
    spec: [
      switch: Stellar.XDR.ManageDataResultCode,
      cases: [
        MANAGE_DATA_SUCCESS: Void
      ],
      default: Void
    ]
end

defmodule Stellar.XDR.OperationResultCode do
  use Enum,
    spec: [
      opINNER: 0,
      opBAD_AUTH: -1,
      opNO_ACCOUNT: -2
    ]
end

defmodule Stellar.XDR.OperationResult do
  use Union,
    spec: [
      switch: Stellar.XDR.OperationResultCode,
      cases: [
        opINNER: OperationResultInner
      ],
      default: Void
    ]

  defmodule OperationResultInner do
    use Union,
      spec: [
        switch: Stellar.XDR.OperationType,
        cases: [
          CREATE_ACCOUNT: Stellar.XDR.CreateAccountResult,
          PAYMENT: Stellar.XDR.PaymentResult,
          PATH_PAYMENT: Stellar.XDR.PathPaymentResult,
          MANAGE_OFFER: Stellar.XDR.ManageOfferResult,
          CREATE_PASSIVE_OFFER: Stellar.XDR.ManageOfferResult,
          SET_OPTIONS: Stellar.XDR.SetOptionsResult,
          CHANGE_TRUST: Stellar.XDR.ChangeTrustResult,
          ALLOW_TRUST: Stellar.XDR.AllowTrustResult,
          ACCOUNT_MERGE: Stellar.XDR.AccountMergeResult,
          INFLATION: Stellar.XDR.InflationResult,
          MANAGE_DATA: Stellar.XDR.ManageDataResult
        ]
      ]
  end
end

defmodule Stellar.XDR.TransactionResultCode do
  use Enum,
    spec: [
      txSUCCESS: 0,
      txFAILED: -1,
      txTOO_EARLY: -2,
      txTOO_LATE: -3,
      txMISSING_OPERATION: -4,
      txBAD_SEQ: -5,
      txBAD_AUTH: -6,
      txINSUFFICIENT_BALANCE: -7,
      txNO_ACCOUNT: -8,
      txINSUFFICIENT_FEE: -9,
      txBAD_AUTH_EXTRA: -10,
      txINTERNAL_ERROR: -11
    ]
end

defmodule Stellar.XDR.TransactionResult do
  use XDR.Type.Struct,
    spec: [
      feeCharged: HyperInt,
      result: Stellar.XDR.TransactionResultResult,
      ext: Stellar.XDR.Ext
    ]

  defmodule TransactionResultResult do
    use Union,
      spec: [
        switch: Stellar.XDR.TransactionResultCode,
        cases: [
          txSUCCESS: OperationResults,
          txFAILED: OperationResults
        ],
        default: Void
      ]

    defmodule OperationResults do
      use VariableArray, spec: [type: Stellar.XDR.OperationResult]
    end
  end
end
