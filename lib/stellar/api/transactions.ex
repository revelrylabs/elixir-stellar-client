defmodule Stellar.API.Transactions do
  @moduledoc """
  Functions for interacting with Transactions
  """
  alias Stellar.Base

  @doc """
  Returns all transactions

  optional `params` can take any of the following.:

  * `cursor`: A paging token, specifying where to start returning records from.

  * `order`: The order in which to return rows, "asc" or "desc".

  * `limit`: Maximum number of records to return.
  """
  @spec all(Keyword.t()) :: {Stellar.status(), map}
  def all(params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/transactions#{query}")
  end

  @doc """
  Gets transaction details
  """
  @spec get(binary) :: {Stellar.status(), map}
  def get(hash) do
    Base.get("/transactions/#{hash}")
  end

  @doc """
  Returns all transactions for given account

  See `all/1` for allowed optional params
  """
  @spec all_for_account(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_account(accountId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/accounts/#{accountId}/transactions#{query}")
  end

  @doc """
  Returns all transactions for given ledger

  See `all/1` for allowed optional params
  """
  @spec all_for_ledger(binary, Keyword.t()) :: {Stellar.status(), map}
  def all_for_ledger(ledgerId, params \\ []) do
    query = Base.process_query_params(params)
    Base.get("/ledgers/#{ledgerId}/transactions#{query}")
  end

  @doc """
  Posts the given Base64 representation of a transaction envelope
  """
  @spec post(binary) :: {Stellar.status(), map}
  def post(transaction) do
    form =
      {:multipart,
       [
         {"tx", transaction}
       ]}

    Base.post("/transactions", form)
  end
end
