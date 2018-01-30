defmodule Stellar.KeyPair do
  @moduledoc """
  Operations for dealing with key pairs
  """
  alias Stellar.StrKey

  @doc """
  Generates a key pair from the given secret
  """
  @spec from_secret(binary) :: {binary, binary}
  def from_secret(secret) do
    decoded_secret = StrKey.decode_check!(:ed25519SecretSeed, secret)
    derived_public_key = Ed25519.derive_public_key(decoded_secret)
    encoded_public_key = StrKey.encode_check!(:ed25519PublicKey, derived_public_key)

    {encoded_public_key, secret}
  end

  @doc """
  Generates a new keypair
  """
  @spec random() :: {binary, binary}
  def random do
    {secret, public_key} = Ed25519.generate_key_pair()
    encoded_public_key = StrKey.encode_check!(:ed25519PublicKey, public_key)
    encoded_secret = StrKey.encode_check!(:ed25519SecretSeed, secret)

    {encoded_public_key, encoded_secret}
  end
end
