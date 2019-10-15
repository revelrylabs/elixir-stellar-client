defmodule Stellar.FeeStats do
  @moduledoc """
  Functions for interacting with FeeStats
  """
  alias Stellar.Base

  @doc """
  Gets fee stats
  """
  @spec get() :: {Stellar.status(), map}
  def get do
    Base.get("/fee_stats")
  end
end
