defmodule Stellar.HttpCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end

  setup do
    bypass = Bypass.open()
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end
end
