defmodule Stellar.XDR.Types.Ledger do
  alias XDR.Type.{
    Enum,
    FixedArray,
    Struct,
    Union,
    VariableArray,
    VariableOpaque
  }

  alias Stellar.XDR.Types.{
    DefaultExt,
    Hash,
    Int32,
    Int64,
    LedgerEntries,
    PublicKey,
    SCP,
    Transaction,
    UInt32,
    UInt64
  }

  alias LedgerEntries.{
    Asset,
    LedgerEntry,
    LedgerEntryType,
    String64
  }

  alias PublicKey, as: AccountID

  alias Transaction.{
    TransactionEnvelope,
    TransactionResult
  }

  alias SCP.{
    SCPEnvelope,
    SCPQuorumSets
  }

  defmodule UpgradeType do
    use VariableOpaque, max_len: 128
  end

  defmodule Upgrades do
    use VariableArray, max_len: 6, type: UpgradeType
  end

  defmodule StellarValue do
    use Struct,
      txSetHash: Hash,
      closeTime: UInt64,
      upgrades: Upgrades,
      ext: DefaultExt
  end

  defmodule SkipList do
    require Stellar.XDR.Types.Hash
    use FixedArray, len: 4, type: Stellar.XDR.Types.Hash
  end

  defmodule LedgerHeader do
    use Struct,
      ledgerVersion: UInt32,
      previousLedgerHash: Hash,
      scpValue: StellarValue,
      txSetResultHash: Hash,
      bucketListHash: Hash,
      ledgerSeq: UInt32,
      totalCoins: Int64,
      feePool: Int64,
      inflationSeq: UInt32,
      idPool: UInt64,
      baseFee: UInt32,
      baseReserve: UInt32,
      maxTxSetSize: UInt32,
      skipList: SkipList,
      ext: DefaultExt
  end

  defmodule LedgerUpgradeType do
    use Enum,
      LEDGER_UPGRADE_VERSION: 1,
      LEDGER_UPGRADE_BASE_FEE: 2,
      LEDGER_UPGRADE_MAX_TX_SET_SIZE: 3,
      LEDGER_UPGRADE_BASE_RESERVE: 4
  end

  defmodule LedgerUpgrade do
    use Union,
      switch: LedgerUpgradeType,
      cases: [
        LEDGER_UPGRADE_VERSION: UInt32,
        LEDGER_UPGRADE_BASE_FEE: UInt32,
        LEDGER_UPGRADE_MAX_TX_SET_SIZE: UInt32,
        LEDGER_UPGRADE_BASE_RESERVE: UInt32
      ]
  end

  defmodule LedgerKeyAccount do
    use Struct,
      accountID: AccountID
  end

  defmodule LedgerKeyTrustLine do
    use Struct,
      accountID: AccountID,
      asset: Asset
  end

  defmodule LedgerKeyOffer do
    use Struct,
      accountID: AccountID,
      offerID: UInt64
  end

  defmodule LedgerKeyData do
    use Struct,
      accountID: AccountID,
      dataName: String64
  end

  defmodule LedgerKey do
    use Union,
      switch: LedgerEntryType,
      cases: [
        ACCOUNT: LedgerKeyAccount,
        TRUSTLINE: LedgerKeyTrustLine,
        OFFER: LedgerKeyOffer,
        DATA: LedgerKeyData
      ]
  end

  defmodule BucketEntryType do
    use Enum,
      LIVEENTRY: 0,
      DEADENTRY: 1
  end

  defmodule BucketEntry do
    use Union,
      switch: BucketEntryType,
      cases: [
        LIVEENTRY: LedgerEntry,
        DEADENTRY: LedgerKey
      ]
  end

  defmodule TransactionEnvelopes do
    use VariableArray, type: TransactionEnvelope
  end

  defmodule TransactionSet do
    use Struct,
      previousLedgerHash: Hash,
      txs: TransactionEnvelopes
  end

  defmodule TransactionResultPair do
    use Struct,
      transactionHash: Hash,
      result: TransactionResult
  end

  defmodule TransactionResultPairs do
    use VariableArray, type: TransactionResultPair
  end

  defmodule TransactionResultSet do
    use Struct,
      results: TransactionResultPairs
  end

  defmodule TransactionHistoryEntry do
    use Struct,
      ledgerSeq: UInt32,
      txSet: TransactionSet,
      ext: DefaultExt
  end

  defmodule TransactionHistoryResultEntry do
    use Struct,
      ledgerSeq: UInt32,
      txResultSet: TransactionResultSet,
      ext: DefaultExt
  end

  defmodule LedgerHeaderHistoryEntry do
    use Struct,
      hash: Hash,
      header: LedgerHeader,
      ext: DefaultExt
  end

  defmodule SCPEnvelopes do
    use VariableArray, type: SCPEnvelope
  end

  defmodule LedgerSCPMessages do
    use Struct,
      ledgerSeq: UInt32,
      messages: SCPEnvelopes
  end

  defmodule SCPHistoryEntryV0 do
    use Struct,
      quorumSets: SCPQuorumSets,
      ledgerMessages: LedgerSCPMessages
  end

  defmodule SCPHistoryEntry do
    use Union,
      switch: Int32,
      cases: [
        {0, SCPHistoryEntryV0}
      ]
  end

  defmodule LedgerEntryChangeType do
    use Enum,
      LEDGER_ENTRY_CREATED: 0,
      LEDGER_ENTRY_UPDATED: 1,
      LEDGER_ENTRY_REMOVED: 2,
      LEDGER_ENTRY_STATE: 3
  end

  defmodule LedgerEntryChange do
    use Union,
      switch: LedgerEntryChangeType,
      cases: [
        LEDGER_ENTRY_CREATED: LedgerEntry,
        LEDGER_ENTRY_UPDATED: LedgerEntry,
        LEDGER_ENTRY_REMOVED: LedgerKey,
        LEDGER_ENTRY_STATE: LedgerEntry
      ]
  end

  defmodule LedgerEntryChanges do
    use VariableArray, type: LedgerEntryChange
  end

  defmodule OperationMeta do
    use Struct,
      changes: LedgerEntryChanges
  end

  defmodule OperationMetas do
    use VariableArray, type: OperationMeta
  end

  defmodule TransactionMetaV1 do
    use Struct,
      txChanges: LedgerEntryChanges,
      operations: OperationMetas
  end

  defmodule TransactionMeta do
    use Union,
      switch: Int32,
      cases: [
        {0, OperationMetas},
        {1, TransactionMetaV1}
      ]
  end
end
