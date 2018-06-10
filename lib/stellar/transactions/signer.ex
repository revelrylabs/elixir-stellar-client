defmodule Stellar.Transactions.Signer do
  alias Stellar.XDR.{
    TransactionEnvelope,
    DecoratedSignatures,
    Transaction
  }

  @spec sign(Transaction.t(), binary) :: DecoratedSignatures.t()
  def sign(transaction, secrets) do
    secrets = List.wrap(secrets)
    hashed = hash(signatureBase(transaction))
    signatures = Enum.map(secrets, fn secret -> Ed25519.signature(hashed, secret) end)
    DecoratedSignatures.new(signatures) |> elem(1)
  end

  @spec verify(binary, Transaction.t(), binary) :: boolean
  def verify(signature, transaction, secret) do
    hashed = hash(signatureBase(transaction))

    Ed25519.valid_signature?(signature, hashed, secret)
  end

  @spec toEnvelope(Transaction.t(), DecoratedSignatures.t()) :: TransactionEnvelope.t()
  def toEnvelope(transaction, signatures) do
    envelope = %TransactionEnvelope{
      tx: transaction,
      signatures: signatures
    }

    # Base.encode64(TransactionEnvelope.encode(envelope))
    envelope
  end

  defp hash(binary) do
    :crypto.hash(:sha256, binary) |> Base.encode16()
  end

  defp signatureBase(transaction) do
    network_id = network_id(Application.get_env(:stellar, :network, :public))
    envelope = Stellar.XDR.EnvelopeType.encode(:ENVELOPE_TYPE_TX)
    encoded_transaction = Stellar.XDR.Transaction.encode(transaction)

    network_id <> envelope <> encoded_transaction
  end

  defp network_id(network) do
    network
    |> network_passphrase()
    |> hash()
  end

  defp network_passphrase(value) do
    case value do
      :public ->
        "Public Global Stellar Network ; September 2015"

      :test ->
        "Test SDF Network ; September 2015"
    end
  end
end
