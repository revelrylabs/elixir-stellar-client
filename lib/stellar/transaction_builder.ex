defmodule Stellar.TransactionBuilder do
  alias Stellar.{TransactionBuilder, Memo}

  # https://github.com/stellar/js-stellar-base/blob/master/src/transaction_builder.js
  defstruct source_account: nil, memo: nil, operations: [], base_fee: 100, time_bounds: nil

  def new(account, opts \\ []) do
    %TransactionBuilder{
      source_account: account,
      base_fee: Keyword.get(opts, :base_fee, 100),
      memo: Keyword.get(opts, :memo, Memo.none()),
      time_bounds: Keyword.get(opts, :time_bounds)
    }
  end

  def add_memo(transaction_builder, memo) do
    %{transaction_builder | memo: memo}
  end

  def add_operation(transaction_builder, operation) do
    %{transaction_builder | operations: transaction_builder.operations ++ [operation]}
  end

  def build(transaction_builder) do
    transaction_builder
  end
end
