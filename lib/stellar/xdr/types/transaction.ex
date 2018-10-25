defmodule Stellar.XDR.Types.Transaction do
  alias XDR.Type.{
    Bool,
    Enum,
    Optional,
    Struct,
    Union,
    Void,
    VariableArray
  }

  alias Stellar.XDR.Types.{
    DefaultExt,
    Hash,
    Int32,
    Int64,
    LedgerEntries,
    PublicKey,
    Signature,
    SignatureHint,
    UInt32,
    UInt64
  }

  alias LedgerEntries.{
    Asset,
    DataValue,
    EnvelopeType,
    OfferEntry,
    Price,
    SequenceNumber,
    Signer,
    String32,
    String64
  }

  alias PublicKey, as: AccountID

  defmodule DecoratedSignature do
    use Struct,
      hint: SignatureHint,
      signature: Signature
  end

  defmodule OperationType do
    use Enum,
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
      MANAGE_DATA: 10,
      BUMP_SEQUENCE: 11
  end

  defmodule CreateAccountOp do
    use Struct,
      destination: AccountID,
      startingBalance: Int64
  end

  defmodule PaymentOp do
    use Struct,
      destination: AccountID,
      asset: Asset,
      amount: Int64
  end

  defmodule AssetPaths do
    use VariableArray, max_len: 5, type: Asset
  end

  defmodule PathPaymentOp do
    use Struct,
      sendAsset: Asset,
      sendMax: Int64,
      destination: AccountID,
      destinationAsset: Asset,
      destinationAmount: Int64,
      path: AssetPaths
  end

  defmodule ManageOfferOp do
    use Struct,
      selling: Asset,
      buying: Asset,
      amount: Int64,
      price: Price,
      offerID: UInt64
  end

  defmodule CreatePassiveOfferOp do
    use Struct,
      selling: Asset,
      buying: Asset,
      amount: Int64,
      price: Price
  end

  defmodule OptionalUInt32 do
    use Optional, for: UInt32
  end

  defmodule OptionalString32 do
    use Optional, for: String32
  end

  defmodule OptionalSigner do
    use Optional, for: Signer
  end

  defmodule SetOptionsOp do
    use Struct,
      inflationDest: AccountID,
      clearFlags: OptionalUInt32,
      setFlags: OptionalUInt32,
      masterWeight: OptionalUInt32,
      lowThreshold: OptionalUInt32,
      medThreshold: OptionalUInt32,
      highThreshold: OptionalUInt32,
      homeDomain: OptionalString32,
      signer: OptionalSigner
  end

  defmodule ChangeTrustOp do
    use Struct,
      line: Asset,
      limit: Int64
  end

  defmodule AllowTrustOp do
    use Struct,
      trustor: AccountID,
      asset: Asset,
      authorize: Bool
  end

  defmodule OptionalDataValue do
    use Optional, for: DataValue
  end

  defmodule ManageDataOp do
    use Struct,
      dataName: String64,
      dataValue: OptionalDataValue
  end

  defmodule BumpSequenceOp do
    use Struct,
      bumpTo: SequenceNumber
  end

  defmodule OperationBody do
    use Union,
      switch: OperationType,
      cases: [
        CREATE_ACCOUNT: CreateAccountOp,
        PAYMENT: PaymentOp,
        PATH_PAYMENT: PathPaymentOp,
        MANAGE_OFFER: ManageOfferOp,
        CREATE_PASSIVE_OFFER: CreatePassiveOfferOp,
        SET_OPTIONS: SetOptionsOp,
        CHANGE_TRUST: ChangeTrustOp,
        ALLOW_TRUST: AllowTrustOp,
        ACCOUNT_MERGE: AccountID,
        INFLATION: Void,
        MANAGE_DATA: ManageDataOp,
        BUMP_SEQUENCE: BumpSequenceOp
      ]
  end

  defmodule Operation do
    use Struct,
      sourceAccount: AccountID,
      body: OperationBody
  end

  defmodule MemoType do
    use Enum,
      MEMO_NONE: 0,
      MEMO_TEXT: 1,
      MEMO_ID: 2,
      MEMO_HASH: 3,
      MEMO_RETURN: 4
  end

  defmodule MemoText do
    use VariableArray, max_len: 28, type: XDR.Type.String
  end

  defmodule Memo do
    use Union,
      switch: MemoType,
      cases: [
        MEMO_NONE: Void,
        MEMO_TEXT: MemoText,
        MEMO_ID: UInt64,
        MEMO_HASH: Hash,
        MEMO_RETURN: Hash
      ]
  end

  defmodule TimeBounds do
    use Struct,
      minTime: UInt64,
      maxTime: UInt64
  end

  defmodule OptionalTimeBounds do
    use Optional, for: TimeBounds
  end

  defmodule Operations do
    use VariableArray, max_len: 100, type: Operation
  end

  defmodule Transaction do
    use Struct,
      sourceAccount: AccountID,
      fee: Int32,
      seqNum: UInt64,
      timeBounds: OptionalTimeBounds,
      memo: Memo,
      operations: Operations,
      ext: DefaultExt
  end

  defmodule TaggedTransaction do
    use Union,
      switch: EnvelopeType,
      cases: [
        ENVELOPE_TYPE_TX: Transaction
      ]
  end

  defmodule TransactionSignaturePayload do
    use Struct,
      networkId: Hash,
      taggedTransaction: TaggedTransaction
  end

  defmodule DecoratedSignatures do
    use VariableArray, max_len: 20, type: DecoratedSignature
  end

  defmodule TransactionEnvelope do
    use Struct,
      tx: Transaction,
      signatures: DecoratedSignatures
  end

  defmodule ClaimOfferAtom do
    use Struct,
      sellerID: AccountID,
      offerID: UInt64,
      assetSold: Asset,
      amountSold: Int64,
      assetBought: Asset,
      amountBought: Int64
  end

  defmodule CreateAccountResultCode do
    use Enum,
      CREATE_ACCOUNT_SUCCESS: 0,
      CREATE_ACCOUNT_MALFORMED: -1,
      CREATE_ACCOUNT_UNDERFUNDED: -2,
      CREATE_ACCOUNT_LOW_RESERVE: -3,
      CREATE_ACCOUNT_ALREADY_EXIST: -4
  end

  defmodule CreateAccountResult do
    use Union,
      switch: CreateAccountResultCode,
      cases: [
        {0, Void}
      ],
      default: Void
  end

  defmodule PaymentResultCode do
    use Enum,
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
  end

  defmodule PaymentResult do
    use Union,
      switch: PaymentResultCode,
      cases: [
        {0, Void}
      ],
      default: Void
  end

  defmodule PathPaymentResultCode do
    use Enum,
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
  end

  defmodule SimplePaymentResult do
    use Struct,
      destination: AccountID,
      asset: Asset,
      amount: Int64
  end

  defmodule ClaimOfferAtoms do
    use VariableArray, type: ClaimOfferAtom
  end

  defmodule PathPaymentSuccess do
    use Struct,
      offers: ClaimOfferAtoms,
      last: SimplePaymentResult
  end

  defmodule PathPaymentResult do
    use Union,
      switch: PathPaymentResultCode,
      cases: [
        PATH_PAYMENT_SUCCESS: PathPaymentSuccess,
        PATH_PAYMENT_NO_ISSUER: Asset
      ]
  end

  defmodule ManageOfferResultCode do
    use Enum,
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
  end

  defmodule ManageOfferEffect do
    use Enum,
      MANAGE_OFFER_CREATED: 0,
      MANAGE_OFFER_UPDATED: 1,
      MANAGE_OFFER_DELETED: 2
  end

  defmodule ManageOfferEffectData do
    use Union,
      switch: ManageOfferEffect,
      cases: [
        MANAGE_OFFER_CREATED: OfferEntry,
        MANAGE_OFFER_UPDATED: OfferEntry,
        MANAGE_OFFER_DELETED: Void
      ]
  end

  defmodule ManageOfferSuccessResult do
    use Struct,
      offersClaimed: ClaimOfferAtoms,
      offer: ManageOfferEffectData
  end

  defmodule ManageOfferResult do
    use Union,
      switch: ManageOfferResultCode,
      cases: [
        MANAGE_OFFER_SUCCESS: ManageOfferSuccessResult
      ],
      default: Void
  end

  defmodule SetOptionsResultCode do
    use Enum,
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
  end

  defmodule SetOptionsResult do
    use Union,
      switch: SetOptionsResultCode,
      cases: [
        SET_OPTIONS_SUCCESS: Void
      ],
      default: Void
  end

  defmodule ChangeTrustResultCode do
    use Enum,
      CHANGE_TRUST_SUCCESS: 0,
      CHANGE_TRUST_MALFORMED: -1,
      CHANGE_TRUST_NO_ISSUER: -2,
      CHANGE_TRUST_INVALID_LIMIT: -3,
      CHANGE_TRUST_LOW_RESERVE: -4,
      CHANGE_TRUST_SELF_NOT_ALLOWED: -5
  end

  defmodule ChangeTrustResult do
    use Union,
      switch: ChangeTrustResultCode,
      cases: [
        CHANGE_TRUST_SUCCESS: Void
      ],
      default: Void
  end

  defmodule AllowTrustResultCode do
    use Enum,
      ALLOW_TRUST_SUCCESS: 0,
      ALLOW_TRUST_MALFORMED: -1,
      ALLOW_TRUST_NO_TRUST_LINE: -2,
      ALLOW_TRUST_TRUST_NOT_REQUIRED: -3,
      ALLOW_TRUST_CANT_REVOKE: -4,
      ALLOW_TRUST_SELF_NOT_ALLOWED: -5
  end

  defmodule AllowTrustResult do
    use Union,
      switch: AllowTrustResultCode,
      cases: [
        ALLOW_TRUST_SUCCESS: Void
      ],
      default: Void
  end

  defmodule AccountMergeResultCode do
    use Enum,
      ACCOUNT_MERGE_SUCCESS: 0,
      ACCOUNT_MERGE_MALFORMED: -1,
      ACCOUNT_MERGE_NO_ACCOUNT: -2,
      ACCOUNT_MERGE_IMMUTABLE_SET: -3,
      ACCOUNT_MERGE_HAS_SUB_ENTRIES: -4
  end

  defmodule AccountMergeResult do
    use Union,
      switch: AccountMergeResultCode,
      cases: [
        ACCOUNT_MERGE_SUCCESS: Int64
      ],
      default: Void
  end

  defmodule InflationResultCode do
    use Enum,
      INFLATION_SUCCESS: 0,
      INFLATION_NOT_TIME: -1
  end

  defmodule InflationPayout do
    use Struct,
      destination: AccountID,
      amount: Int64
  end

  defmodule Payouts do
    use VariableArray, type: InflationPayout
  end

  defmodule InflationResult do
    use Union,
      switch: InflationResultCode,
      cases: [
        INFLATION_SUCCESS: Payouts
      ],
      default: Void
  end

  defmodule ManageDataResultCode do
    use Enum,
      MANAGE_DATA_SUCCESS: 0,
      MANAGE_DATA_NOT_SUPPORTED_YET: -1,
      MANAGE_DATA_NAME_NOT_FOUND: -2,
      MANAGE_DATA_LOW_RESERVE: -3,
      MANAGE_DATA_INVALID_NAME: -4
  end

  defmodule ManageDataResult do
    use Union,
      switch: ManageDataResultCode,
      cases: [
        MANAGE_DATA_SUCCESS: Void
      ],
      default: Void
  end

  defmodule BumpSequenceResultCode do
    use Enum,
      BUMP_SEQUENCE_SUCCESS: 0,
      BUMP_SEQUENCE_BAD_SEQ: -1
  end

  defmodule BumpSequenceResult do
    use Union,
      switch: BumpSequenceResultCode,
      cases: [
        BUMP_SEQUENCE_SUCCESS: Void
      ],
      default: Void
  end

  defmodule OperationResultCode do
    use Enum,
      opINNER: 0,
      opBAD_AUTH: -1,
      opNO_ACCOUNT: -2,
      opNOT_SUPPORTED: -3
  end

  defmodule OperationResult do
    use Union,
      switch: OperationResultCode,
      cases: [
        opINNER: OperationResultInner
      ],
      default: Void

    defmodule OperationResultInner do
      use Union,
        switch: OperationType,
        cases: [
          CREATE_ACCOUNT: CreateAccountResult,
          PAYMENT: PaymentResult,
          PATH_PAYMENT: PathPaymentResult,
          MANAGE_OFFER: ManageOfferResult,
          CREATE_PASSIVE_OFFER: ManageOfferResult,
          SET_OPTIONS: SetOptionsResult,
          CHANGE_TRUST: ChangeTrustResult,
          ALLOW_TRUST: AllowTrustResult,
          ACCOUNT_MERGE: AccountMergeResult,
          INFLATION: InflationResult,
          MANAGE_DATA: ManageDataResult,
          BUMP_SEQUENCE: BumpSequenceResult
        ]
    end
  end

  defmodule TransactionResultCode do
    use Enum,
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
  end

  defmodule OperationResults do
    use VariableArray, type: OperationResult
  end

  defmodule TransactionResultResult do
    use Union,
      switch: TransactionResultCode,
      cases: [
        txSUCCESS: OperationResults,
        txFAILED: OperationResults
      ],
      default: Void
  end

  defmodule TransactionResult do
    use Struct,
      feeCharged: Int64,
      result: TransactionResultResult,
      ext: DefaultExt
  end
end
