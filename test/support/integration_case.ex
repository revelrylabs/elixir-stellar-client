defmodule Stellar.IntegrationCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end

  setup do
    Application.put_env(:stellar, :network, :test)
    test_account = Application.get_env(:stellar, :test_account)
    {:ok, test_account}
  end
end
