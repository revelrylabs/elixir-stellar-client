defmodule Stellar.StrKey.Test do
  use ExUnit.Case, async: true
  alias Stellar.{StrKey, KeyPair}

  test "encode_check! with nil data raises" do
    assert_raise ArgumentError, fn ->
      StrKey.encode_check!(:ed25519SecretSeed, nil)
    end
  end

  test "encode_check! with invalid version_byte_name raises" do
    data =
      <<85, 170, 163, 24, 149, 77, 255, 19, 245, 22, 224, 124, 2, 45, 42, 241, 162, 2, 23, 25,
        226, 47, 133, 151, 8, 76, 130, 155, 252, 4, 95, 22>>

    assert_raise ArgumentError, fn ->
      StrKey.encode_check!(:something, data)
    end
  end

  test "decode_check! with unknown version_byte_name raises" do
    data = "SBK2VIYYSVG76E7VC3QHYARNFLY2EAQXDHRC7BMXBBGIFG74ARPRMNQM"

    assert_raise ArgumentError, fn ->
      StrKey.decode_check!(:something, data)
    end
  end

  test "decode_check! with version_byte_name not matching raises" do
    data = "SBK2VIYYSVG76E7VC3QHYARNFLY2EAQXDHRC7BMXBBGIFG74ARPRMNQM"

    assert_raise ArgumentError, fn ->
      StrKey.decode_check!(:ed25519PublicKey, data)
    end
  end

  test "decode_check! with checksum not matching raises" do
    data = "SBK2VIYYSVG76E7VC3QHYARNFLY2EAQXDHRC7BMXBBGIFG74ARPRMNMQ"

    assert_raise ArgumentError, fn ->
      StrKey.decode_check!(:ed25519SecretSeed, data)
    end
  end

  test "decode_check! to encode_check! and back" do
    Enum.each(1..10, fn _ ->
      {public, secret} = KeyPair.random()

      data = StrKey.decode_check!(:ed25519SecretSeed, secret)
      assert secret == StrKey.encode_check!(:ed25519SecretSeed, data)

      data = StrKey.decode_check!(:ed25519PublicKey, public)
      assert public == StrKey.encode_check!(:ed25519PublicKey, data)
    end)
  end
end
