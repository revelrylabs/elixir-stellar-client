defmodule Stellar.XDR.Types.Transaction do
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

  alias Stellar.XDR.Types.{SignatureHint, Signature, Hash}
  alias Stellar.XDR.Types.PublicKey, as: AccountID

  alias Stellar.Types.LedgerEntries.{
    Asset,
    Price,
    String32,
    Signer,
    AssetCode4,
    AssetCode12,
    String64,
    DataValue,
    Ext,
    OfferEntry
  }

  defmodule DecoratedSignature do
    use XDR.Type.Struct,
      spec: [
        hint: SignatureHint,
        signature: Signature
      ]
  end

  defmodule OperationType do
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

  defmodule CreateAccountOp do
    use XDR.Type.Struct,
      spec: [
        destination: AccountID,
        startingBalance: HyperInt
      ]
  end

  defmodule PaymentOp do
    use XDR.Type.Struct,
      spec: [
        destination: AccountID,
        asset: Asset,
        amount: HyperInt
      ]
  end

  defmodule PathPaymentOp do
    use XDR.Type.Struct,
      spec: [
        sendAsset: Asset,
        sendMax: HyperInt,
        destination: AccountID,
        destinationAsset: Asset,
        destinationAmount: HyperInt,
        path: AssetPaths
      ]

    defmodule AssetPaths do
      use VariableArray, spec: [max_len: 5, type: Asset]
    end
  end

  defmodule ManageOfferOp do
    use XDR.Type.Struct,
      spec: [
        selling: Asset,
        buying: Asset,
        amount: HyperInt,
        price: Price,
        offerID: HyperUint
      ]
  end

  defmodule CreatePassiveOfferOp do
    use XDR.Type.Struct,
      spec: [
        selling: Asset,
        buying: Asset,
        amount: HyperInt,
        price: Price
      ]
  end

  defmodule SetOptionsOp do
    use XDR.Type.Struct,
      spec: [
        inflationDest: AccountID,
        clearFlags: Uint,
        setFlags: Uint,
        masterWeight: Uint,
        lowThreshold: Uint,
        medThreshold: Uint,
        highThreshold: Uint,
        homeDomain: String32,
        signer: Signer
      ]
  end

  defmodule ChangeTrustOp do
    use XDR.Type.Struct,
      spec: [
        line: Asset,
        limit: HyperInt
      ]
  end

  defmodule AllowTrustOp do
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
            {1, AssetCode4},
            {2, AssetCode12}
          ]
        ]
    end
  end

  defmodule ManageDataOp do
    use XDR.Type.Struct,
      spec: [
        dataName: String64,
        dataValue: DataValue
      ]
  end

  defmodule Operation do
    use XDR.Type.Struct,
      spec: [
        sourceAccount: AccountID,
        body: OperationUnion
      ]

    defmodule OperationUnion do
      use Union,
        spec: [
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
        ]
    end
  end

  defmodule MemoType do
    use Enum,
      spec: [
        MEMO_NONE: 0,
        MEMO_TEXT: 1,
        MEMO_ID: 2,
        MEMO_HASH: 3,
        MEMO_RETURN: 4
      ]
  end

  defmodule Text do
    use VariableArray, spec: [max_len: 28, type: XDR.Type.String]
  end

  defmodule Memo do
    use Union,
      spec: [
        switch: MemoType,
        cases: [
          {0, Void},
          {1, Text},
          {2, HyperUint},
          {3, Hash},
          {4, Hash}
        ]
      ]
  end

  defmodule TimeBounds do
    use XDR.Type.Struct,
      spec: [
        minTime: HyperUint,
        maxTime: HyperUint
      ]
  end

  defmodule Transaction do
    use XDR.Type.Struct,
      spec: [
        sourceAccount: AccountID,
        fee: Int,
        seqNum: HyperUint,
        timeBounds: TimeBounds,
        memo: Memo,
        operations: Operations,
        ext: Ext
      ]

    defmodule Operations do
      use VariableArray, spec: [max_len: 100, type: Operation]
    end
  end

  defmodule TransactionSignaturePayload do
    use XDR.Type.Struct,
      spec: [
        networkId: Hash,
        taggedTransaction: TaggedTransaction
      ]

    defmodule TaggedTransaction do
      use Union,
        spec: [
          switch: MemoType,
          cases: [
            {0, Transaction}
          ]
        ]
    end
  end

  defmodule DecoratedSignatures do
    use VariableArray, spec: [max_len: 20, type: DecoratedSignature]
  end

  defmodule TransactionEnvelope do
    use XDR.Type.Struct,
      spec: [
        tx: Transaction,
        signatures: DecoratedSignatures
      ]
  end

  defmodule ClaimOfferAtom do
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

  defmodule CreateAccountResultCode do
    use Enum,
      spec: [
        CREATE_ACCOUNT_SUCCESS: 0,
        CREATE_ACCOUNT_MALFORMED: -1,
        CREATE_ACCOUNT_UNDERFUNDED: -2,
        CREATE_ACCOUNT_LOW_RESERVE: -3,
        CREATE_ACCOUNT_ALREADY_EXIST: -4
      ]
  end

  defmodule CreateAccountResult do
    use Union,
      spec: [
        switch: CreateAccountResultCode,
        cases: [
          {0, VOID}
        ]
      ]
  end

  defmodule PaymentResultCode do
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

  defmodule PaymentResult do
    use Union,
      spec: [
        switch: PaymentResultCode,
        cases: [
          {0, VOID}
        ]
      ]
  end

  defmodule PathPaymentResultCode do
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

  defmodule SimplePaymentResult do
    use XDR.Type.Struct,
      spec: [
        destination: AccountID,
        asset: Asset,
        amount: HyperInt
      ]
  end

  defmodule PathPaymentResult do
    use Union,
      spec: [
        switch: PathPaymentResultCode,
        cases: [
          {0, PaymentSuccess},
          {-9, Asset}
        ]
      ]

    defmodule PaymentSuccess do
      use XDR.Type.Struct,
        spec: [
          offers: ClaimOfferAtoms,
          last: SimplePaymentResult
        ]

      defmodule ClaimOfferAtoms do
        use VariableArray, spec: [type: ClaimOfferAtom]
      end
    end
  end

  defmodule ManageOfferResultCode do
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

  defmodule ManageOfferEffect do
    use Enum,
      spec: [
        MANAGE_OFFER_CREATED: 0,
        MANAGE_OFFER_UPDATED: 1,
        MANAGE_OFFER_DELETED: 2
      ]
  end

  defmodule ClaimOfferAtoms do
    use VariableArray, spec: [type: ClaimOfferAtom]
  end

  defmodule ManageOfferSuccessResult do
    use XDR.Type.Struct,
      spec: [
        offersClaimed: ClaimOfferAtoms,
        offer: OfferUnion
      ]

    defmodule OfferUnion do
      use Union,
        spec: [
          switch: ManageOfferEffect,
          cases: [
            {0, OfferEntry},
            {1, OfferEntry},
            {2, VOID}
          ]
        ]
    end
  end

  defmodule ManageOfferResult do
    use Union,
      spec: [
        switch: ManageOfferResultCode,
        cases: [
          {0, ManageOfferSuccessResult}
        ]
      ]
  end

  defmodule SetOptionsResultCode do
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

  defmodule SetOptionsResult do
    use Union,
      spec: [
        switch: SetOptionsResultCode,
        cases: [
          {0, VOID}
        ]
      ]
  end

  defmodule ChangeTrustResultCode do
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

  defmodule ChangeTrustResult do
    use Union,
      spec: [
        switch: ChangeTrustResultCode,
        cases: [
          {0, VOID}
        ]
      ]
  end

  defmodule AllowTrustResultCode do
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

  defmodule AllowTrustResult do
    use Union,
      spec: [
        switch: AllowTrustResultCode,
        cases: [
          {0, VOID}
        ]
      ]
  end

  defmodule AccountMergeResultCode do
    use Enum,
      spec: [
        ACCOUNT_MERGE_SUCCESS: 0,
        ACCOUNT_MERGE_MALFORMED: -1,
        ACCOUNT_MERGE_NO_ACCOUNT: -2,
        ACCOUNT_MERGE_IMMUTABLE_SET: -3,
        ACCOUNT_MERGE_HAS_SUB_ENTRIES: -4
      ]
  end

  defmodule AccountMergeResult do
    use Union,
      spec: [
        switch: AccountMergeResultCode,
        cases: [
          {0, HyperInt},
          {-1, VOID}
        ]
      ]
  end

  defmodule InflationResultCode do
    use Enum,
      spec: [
        INFLATION_SUCCESS: 0,
        INFLATION_NOT_TIME: -1
      ]
  end

  defmodule InflationPayout do
    use XDR.Type.Struct,
      spec: [
        destination: AccountID,
        amount: HyperInt
      ]
  end

  defmodule InflationResult do
    use Union,
      spec: [
        switch: InflationResultCode,
        cases: [
          {0, Payouts},
          {-1, VOID}
        ]
      ]

    defmodule Payouts do
      use VariableArray, spec: [type: InflationPayout]
    end
  end

  defmodule ManageDataResultCode do
    use Enum,
      spec: [
        MANAGE_DATA_SUCCESS: 0,
        MANAGE_DATA_NOT_SUPPORTED_YET: -1,
        MANAGE_DATA_NAME_NOT_FOUND: -2,
        MANAGE_DATA_LOW_RESERVE: -3,
        MANAGE_DATA_INVALID_NAME: -4
      ]
  end

  defmodule ManageDataResult do
    use Union,
      spec: [
        switch: ManageDataResultCode,
        cases: [
          {0, VOID}
        ]
      ]
  end

  defmodule OperationResultCode do
    use Enum,
      spec: [
        opINNER: 0,
        opBAD_AUTH: -1,
        opNO_ACCOUNT: -2
      ]
  end

  defmodule OperationResult do
    use Union,
      spec: [
        switch: OperationResultCode,
        cases: [
          {0, OperationResultInner}
        ]
      ]

    defmodule OperationResultInner do
      use Union,
        spec: [
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
        ]
    end
  end

  defmodule TransactionResultCode do
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

  defmodule TransactionResult do
    use XDR.Type.Struct,
      spec: [
        feeCharged: HyperInt,
        result: TransactionResultResult,
        ext: Ext
      ]

    defmodule TransactionResultResult do
      use Union,
        spec: [
          switch: TransactionResultCode,
          cases: [
            {0, OperationResults},
            {-1, OperationResults},
            {-2, VOID}
          ]
        ]

      defmodule OperationResults do
        use VariableArray, spec: [type: OperationResult]
      end
    end
  end
end
