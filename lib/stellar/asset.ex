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

  def asset_type(%Asset{issuer: nil}) do
    "native"
  end

  def asset_type(%Asset{code: code}) when length(code) >= 1 and length(code) <= 4 do
    "credit_alphanum4"
  end

  def asset_type(_) do
    "credit_alphanum12"
  end

  def to_xdr(asset) do
    nil
  end
end
