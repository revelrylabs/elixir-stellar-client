defmodule Stellar.StrKey do
  @moduledoc false

  # Logic copied from https://github.com/stellar/js-stellar-base/blob/master/src/strkey.js

  import Bitwise

  @version_bytes %{
    # G
    ed25519PublicKey: 6 <<< 3,
    # S
    ed25519SecretSeed: 18 <<< 3,
    # T
    preAuthTx: 19 <<< 3,
    # X
    sha256Hash: 23 <<< 3
  }

  def encode_check!(_, nil) do
    raise ArgumentError, "cannot encode nil data"
  end

  def encode_check!(version_byte_name, _)
      when version_byte_name not in [
             :ed25519PublicKey,
             :ed25519SecretSeed,
             :preAuthTx,
             :sha256Hash
           ] do
    raise ArgumentError,
          "#{version_byte_name} is not a valid version byte name.  expected one of :ed25519PublicKey, :ed25519SecretSeed, :preAuthTx, :sha256Hash"
  end

  def encode_check!(version_byte_name, data) do
    version_byte = @version_bytes[version_byte_name]

    payload = <<version_byte>> <> data
    checksum = CRC.crc(:crc_16_xmodem, payload)
    unencoded = payload <> <<checksum::little-16>>
    Base.encode32(unencoded, padding: false)
  end

  def decode_check!(version_byte_name, encoded) do
    decoded = Base.decode32!(encoded)
    <<version_byte::size(8), data::binary-size(32), checksum::little-integer-size(16)>> = decoded

    expected_version = @version_bytes[version_byte_name]

    if is_nil(expected_version) do
      raise ArgumentError, "#{version_byte_name} is not a valid version byte name"
    end

    if version_byte != expected_version do
      raise ArgumentError,
            "invalid version byte. expected #{expected_version}, got #{version_byte}"
    end

    expected_checksum = CRC.crc(:crc_16_xmodem, <<version_byte>> <> data)

    if checksum != expected_checksum do
      raise ArgumentError, "invalid checksum"
    end

    data
  end
end
