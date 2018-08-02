defmodule Stellar.XDR.Types do
  alias XDR.Type.{
    Enum,
    FixedOpaque,
    HyperInt,
    HyperUint,
    Int,
    Uint,
    Union,
    VariableOpaque
  }

  defmodule UInt32 do
    use Uint
  end

  defmodule UInt64 do
    use HyperUint
  end

  defmodule UInt256 do
    use FixedOpaque, len: 32
  end

  defmodule Int32 do
    use Int
  end

  defmodule Int64 do
    use HyperInt
  end

  defmodule Hash do
    use FixedOpaque, len: 32
  end

  defmodule CryptoKeyType do
    use Enum,
      KEY_TYPE_ED25519: 0,
      KEY_TYPE_PRE_AUTH_TX: 1,
      KEY_TYPE_HASH_X: 2
  end

  defmodule PublicKeyType do
    use Enum,
      PUBLIC_KEY_TYPE_ED25519: 0
  end

  defmodule SignerKeyType do
    use Enum,
      SIGNER_KEY_TYPE_ED25519: 0,
      SIGNER_KEY_TYPE_PRE_AUTH_TX: 1,
      SIGNER_KEY_TYPE_HASH_X: 2
  end

  defmodule PublicKey do
    use Union,
      switch: PublicKeyType,
      cases: [
        {0, UInt256}
      ]
  end

  defmodule SignerKey do
    use Union,
      switch: SignerKeyType,
      cases: [
        {0, UInt256},
        {1, UInt256},
        {2, UInt256}
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
      key: Key32
  end

  defmodule Curve25519Public do
    use XDR.Type.Struct,
      key: Key32
  end

  defmodule HmacSha256Key do
    use XDR.Type.Struct,
      key: Key32
  end

  defmodule HmacSha256Mac do
    use XDR.Type.Struct,
      mac: Key32
  end
end
