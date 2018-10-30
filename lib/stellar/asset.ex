defmodule Stellar.Asset do
  # https://github.com/stellar/js-stellar-base/blob/master/src/asset.js

  alias Stellar.Asset

  defstruct code: nil, issuer: nil

  def native() do
    %Asset{code: "XLM"}
  end

  def new(code, issuer) do
    %Asset{code: code, issuer: issuer}
  end
end
