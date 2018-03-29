defmodule Stellar.Types do
  alias XDR.Type.{FixedOpaque, Enum, Union, VariableOpaque}

  defmodule Hash do
    use FixedOpaque, len: 32
  end

  defmodule UInt256 do
    use FixedOpaque, len: 32
  end

  defmodule CryptoKeyType do
    use Enum,
      spec: [
        KEY_TYPE_ED25519: 0,
        KEY_TYPE_PRE_AUTH_TX: 1,
        KEY_TYPE_HASH_X: 2
      ]
  end

  defmodule PublicKeyType do
    use Enum,
      spec: [
        PUBLIC_KEY_TYPE_ED25519: 0
      ]
  end

  defmodule SignerKeyType do
    use Enum,
      spec: [
        SIGNER_KEY_TYPE_ED25519: 0,
        SIGNER_KEY_TYPE_PRE_AUTH_TX: 1,
        SIGNER_KEY_TYPE_HASH_X: 2
      ]
  end

  defmodule PublicKey do
    use Union,
      spec: [
        switch: PublicKeyType,
        cases: [
          {0, UInt256}
        ]
      ]
  end

  defmodule NodeID do
    use Union,
      spec: [
        switch: PublicKeyType,
        cases: [
          {0, UInt256}
        ]
      ]
  end

  defmodule SignerKey do
    use Union,
      spec: [
        switch: SignerKeyType,
        cases: [
          {0, UInt256},
          {1, UInt256},
          {2, UInt256}
        ]
      ]
  end

  defmodule Signature do
    use VariableOpaque, max_len: 64
  end

  defmodule SignatureHint do
    use FixedOpaque, len: 4
  end

  defmodule Key32 do
    use FixedOpaque, len: 32
  end

  defmodule Curve25519Secret do
    use XDR.Type.Struct,
      spec: [
        key: Key32
      ]
  end

  defmodule Curve25519Public do
    use XDR.Type.Struct,
      spec: [
        key: Key32
      ]
  end

  defmodule HmacSha256Key do
    use XDR.Type.Struct,
      spec: [
        key: Key32
      ]
  end

  defmodule HmacSha256Mac do
    use XDR.Type.Struct,
      spec: [
        mac: Key32
      ]
  end
end
