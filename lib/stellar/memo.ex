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
end
