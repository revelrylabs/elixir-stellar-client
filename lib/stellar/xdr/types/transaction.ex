defmodule Stellar.XDR.Types.Transaction do
  alias XDR.Type.{
    Enum,
    Union,
    Void,
    VariableArray
  }

  alias Stellar.XDR.Types.{
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
    AssetType,
    AssetCode4,
    AssetCode12,
    DataValue,
    OfferEntry,
    Price,
    Signer,
    String32,
    String64
  }

  alias PublicKey, as: AccountID

  defmodule Ext do
    use Union,
      switch: Int32,
      cases: [
        {0, Void}
      ]
  end

  defmodule DecoratedSignature do
    use XDR.Type.Struct,
      hint: SignatureHint,
      signature: Signature
  end

  defmodule DecoratedSignatures do
    use VariableArray, max_len: 20, type: DecoratedSignature
  end

  defmodule AssetPaths do
    use VariableArray, max_len: 5, type: Asset
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
      MANAGE_DATA: 10
  end

  defmodule CreateAccountOp do
    use XDR.Type.Struct,
      destination: AccountID,
      startingBalance: Int64
  end

  defmodule PaymentOp do
    use XDR.Type.Struct,
      destination: AccountID,
      asset: Asset,
      amount: Int64
  end

  defmodule PathPaymentOp do
    use XDR.Type.Struct,
      sendAsset: Asset,
      sendMax: Int64,
      destination: AccountID,
      destinationAsset: Asset,
      destinationAmount: Int64,
      path: AssetPaths
  end

  defmodule ManageOfferOp do
    use XDR.Type.Struct,
      selling: Asset,
      buying: Asset,
      amount: Int64,
      price: Price,
      offerID: UInt64
  end

  defmodule CreatePassiveOfferOp do
    use XDR.Type.Struct,
      selling: Asset,
      buying: Asset,
      amount: Int64,
      price: Price
  end

  defmodule SetOptionsOp do
    use XDR.Type.Struct,
      inflationDest: AccountID,
      clearFlags: UInt32,
      setFlags: UInt32,
      masterWeight: UInt32,
      lowThreshold: UInt32,
      medThreshold: UInt32,
      highThreshold: UInt32,
      homeDomain: String32,
      signer: Signer
  end

  defmodule ChangeTrustOp do
    use XDR.Type.Struct,
      line: Asset,
      limit: Int64
  end

  defmodule Asset do
    use Union,
      switch: AssetType,
      cases: [
        {1, AssetCode4},
        {2, AssetCode12}
      ]
  end

  defmodule AllowTrustOp do
    use XDR.Type.Struct,
      trustor: AccountID,
      asset: Asset
  end

  defmodule ManageDataOp do
    use XDR.Type.Struct,
      dataName: String64,
      dataValue: DataValue
  end

  defmodule OperationUnion do
    use Union,
      switch: OperationType,
      cases: [
        {0, CreateAccountOp},
        {1, PaymentOp},
        {2, PathPaymentOp},
        {3, ManageOfferOp},
        {4, CreatePassiveOfferOp},
        {5, SetOptionsOp},
        {6, ChangeTrustOp},
        {7, AllowTrustOp},
        {8, AccountID},
        {9, Void},
        {10, ManageDataOp}
      ]
  end

  defmodule Operation do
    use XDR.Type.Struct,
      sourceAccount: AccountID,
      body: OperationUnion
  end

  defmodule Operations do
    use VariableArray, max_len: 100, type: Operation
  end

  defmodule MemoType do
    use Enum,
      MEMO_NONE: 0,
      MEMO_TEXT: 1,
      MEMO_ID: 2,
      MEMO_HASH: 3,
      MEMO_RETURN: 4
  end

  defmodule Text do
    use VariableArray, max_len: 28, type: XDR.Type.String
  end

  defmodule Memo do
    use Union,
      switch: MemoType,
      cases: [
        {0, Void},
        {1, Text},
        {2, UInt64},
        {3, Hash},
        {4, Hash}
      ]
  end

  defmodule TimeBounds do
    use XDR.Type.Struct,
      minTime: UInt64,
      maxTime: UInt64
  end

  defmodule Transaction do
    use XDR.Type.Struct,
      sourceAccount: AccountID,
      fee: Int32,
      seqNum: UInt64,
      timeBounds: TimeBounds,
      memo: Memo,
      operations: Operations,
      ext: Ext
  end

  defmodule TaggedTransaction do
    use Union,
      switch: MemoType,
      cases: [
        {0, Transaction}
      ]
  end

  defmodule TransactionSignaturePayload do
    use XDR.Type.Struct,
      networkId: Hash,
      taggedTransaction: TaggedTransaction
  end

  defmodule TransactionEnvelope do
    use XDR.Type.Struct,
      tx: Transaction,
      signatures: DecoratedSignatures
  end

  defmodule ClaimOfferAtom do
    use XDR.Type.Struct,
      sellerID: AccountID,
      offerID: UInt64,
      assetSold: Asset,
      amountSold: Int64,
      assetBought: Asset,
      amountBought: Int64
  end

  defmodule ClaimOfferAtoms do
    use VariableArray, type: ClaimOfferAtom
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
        {0, VOID}
      ]
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
        {0, VOID}
      ]
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
    use XDR.Type.Struct,
      destination: AccountID,
      asset: Asset,
      amount: Int64
  end

  defmodule PathPaymentResult do
    use Union,
      switch: PathPaymentResultCode,
      cases: [
        {0, PaymentSuccess},
        {-9, Asset}
      ]

    defmodule PaymentSuccess do
      use XDR.Type.Struct,
        offers: ClaimOfferAtoms,
        last: SimplePaymentResult
    end
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

  defmodule OfferUnion do
    use Union,
      switch: ManageOfferEffect,
      cases: [
        {0, OfferEntry},
        {1, OfferEntry},
        {2, VOID}
      ]
  end

  defmodule ManageOfferSuccessResult do
    use XDR.Type.Struct,
      offersClaimed: ClaimOfferAtoms,
      offer: OfferUnion
  end

  defmodule ManageOfferResult do
    use Union,
      switch: ManageOfferResultCode,
      cases: [
        {0, ManageOfferSuccessResult}
      ]
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
        {0, VOID}
      ]
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
        {0, VOID}
      ]
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
        {0, VOID}
      ]
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
        {0, Int64},
        {-1, VOID}
      ]
  end

  defmodule InflationResultCode do
    use Enum,
      INFLATION_SUCCESS: 0,
      INFLATION_NOT_TIME: -1
  end

  defmodule InflationPayout do
    use XDR.Type.Struct,
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
        {0, Payouts},
        {-1, VOID}
      ]
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
        {0, VOID}
      ]
  end

  defmodule OperationResultCode do
    use Enum,
      opINNER: 0,
      opBAD_AUTH: -1,
      opNO_ACCOUNT: -2
  end

  defmodule OperationResult do
    use Union,
      switch: OperationResultCode,
      cases: [
        {0, OperationResultInner}
      ]

    defmodule OperationResultInner do
      use Union,
        switch: OperationType,
        cases: [
          {0, CreateAccountResult},
          {1, PaymentResult},
          {2, PathPaymentResult},
          {3, ManageOfferResult},
          {4, ManageOfferResult},
          {5, SetOptionsResult},
          {6, ChangeTrustResult},
          {7, AllowTrustResult},
          {8, AccountMergeResult},
          {9, InflationResult},
          {10, ManageDataResult}
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
        {0, OperationResults},
        {-1, OperationResults},
        {-2, VOID}
      ]
  end

  defmodule TransactionResult do
    use XDR.Type.Struct,
      feeCharged: Int64,
      result: TransactionResultResult,
      ext: Ext
  end
end
