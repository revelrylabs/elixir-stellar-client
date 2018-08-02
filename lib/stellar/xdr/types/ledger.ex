defmodule Stellar.XDR.Types.Ledger do
  alias XDR.Type.{
    Enum,
    FixedArray,
    Union,
    VariableArray,
    VariableOpaque,
    Void
  }

  alias Stellar.XDR.Types.{
    Hash,
    Int32,
    Int64,
    UInt32,
    UInt64
  }

  defmodule Ext do
    use Union,
      switch: Int32,
      cases: [
        {0, Void}
      ]
  end

  defmodule UpgradeType do
    use VariableOpaque, max_len: 128
  end

  defmodule Upgrades do
    use VariableArray, max_len: 6, type: UpgradeType
  end

  defmodule StellarValue do
    require Ext

    use XDR.Type.Struct,
      txSetHash: Hash,
      closeTime: UInt64,
      upgrades: Upgrades,
      ext: Ext
  end

  defmodule SkipList do
    require Stellar.XDR.Types.Hash
    use FixedArray, len: 4, type: Stellar.XDR.Types.Hash
  end

  defmodule LedgerHeader do
    require Ext

    use XDR.Type.Struct,
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
      ext: Ext
  end

  defmodule LedgerUpgradeType do
    use Enum,
      LEDGER_UPGRADE_VERSION: 1,
      LEDGER_UPGRADE_BASE_FEE: 2,
      LEDGER_UPGRADE_MAX_TX_SET_SIZE: 3,
      LEDGER_UPGRADE_BASE_RESERVE: 4
  end
end
