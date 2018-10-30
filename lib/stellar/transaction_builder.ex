defmodule Stellar.TransactionBuilder do
  # https://github.com/stellar/js-stellar-base/blob/master/src/transaction_builder.js
  defstruct source_account: nil, memo: nil, operations: [], base_fee: 100

  def new(account, opts \\ []) do
  end

  def with_memo(trasaction_builder, memo) do
  end

  def with_operation(trasaction_builder, operation) do
  end

  def build(trasaction_builder) do
  end
end
