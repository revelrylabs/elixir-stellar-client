defmodule Stellar.Memo do
  alias Stellar.Memo

  defstruct type: nil, value: nil

  def none() do
    %Memo{type: "none"}
  end

  def id(id) do
    %Memo{type: "id", value: id}
  end

  def text(text) do
    %Memo{type: "text", value: text}
  end

  def hash(hash) do
    %Memo{type: "hash", value: hash}
  end

  def return(hash) do
    %Memo{type: "return", value: hash}
  end

  def to_xdr(memo) do
    case memo.type do
      "none" ->
        Stellar.XDR.Types.Transaction.Memo.encode({:MEMO_NONE, XDR.Type.Void.encode(nil)})

      "id" ->
        Stellar.XDR.Types.Transaction.Memo.encode({:MEMO_ID, memo.value})

      "text" ->
        Stellar.XDR.Types.Transaction.Memo.encode({:MEMO_TEXT, memo.value})

      "hash" ->
        Stellar.XDR.Types.Transaction.Memo.encode({:MEMO_HASH, memo.value})

      "return" ->
        Stellar.XDR.Types.Transaction.Memo.encode({:MEMO_RETURN, memo.value})
    end
  end
end
