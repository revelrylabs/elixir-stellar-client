defmodule Stellar.Metrics do
  @moduledoc """
  Functions for interacting with Metrics
  """
  alias Stellar.Base

  @doc """
  Gets metrics
  """
  @spec get() :: {Stellar.status(), map}
  def get do
    Base.get("/metrics")
  end
end
