defmodule Stellar.XDR.Hash do
  use XDR.Type.FixedOpaque, len: 32
end

defmodule Stellar.XDR.UInt256 do
  use XDR.Type.FixedOpaque, len: 32
end

defmodule Stellar.XDR.CryptoKeyType do
  use XDR.Type.Enum,
    spec: [
      KEY_TYPE_ED25519: 0,
      KEY_TYPE_PRE_AUTH_TX: 1,
      KEY_TYPE_HASH_X: 2
    ]
end

defmodule Stellar.XDR.PublicKeyType do
  use XDR.Type.Enum,
    spec: [
      PUBLIC_KEY_TYPE_ED25519: 0
    ]
end

defmodule Stellar.XDR.SignerKeyType do
  use XDR.Type.Enum,
    spec: [
      SIGNER_KEY_TYPE_ED25519: 0,
      SIGNER_KEY_TYPE_PRE_AUTH_TX: 1,
      SIGNER_KEY_TYPE_HASH_X: 2
    ]
end

defmodule Stellar.XDR.PublicKey do
  use XDR.Type.Union,
    spec: [
      switch: Stellar.XDR.PublicKeyType,
      cases: [
        PUBLIC_KEY_TYPE_ED25519: Stellar.XDR.UInt256
      ]
    ]
end

defmodule Stellar.XDR.SignerKey do
  use XDR.Type.Union,
    spec: [
      switch: Stellar.XDR.SignerKeyType,
      cases: [
        SIGNER_KEY_TYPE_ED25519: Stellar.XDR.UInt256,
        SIGNER_KEY_TYPE_PRE_AUTH_TX: Stellar.XDR.UInt256,
        SIGNER_KEY_TYPE_HASH_X: Stellar.XDR.UInt256
      ]
    ]
end

defmodule Stellar.XDR.Signature do
  use XDR.Type.VariableOpaque, max_len: 64
end

defmodule Stellar.XDR.SignatureHint do
  use XDR.Type.FixedOpaque, len: 4
end

defmodule Stellar.XDR.Key32 do
  use XDR.Type.FixedOpaque, len: 32
end

defmodule Stellar.XDR.Curve25519Secret do
  use XDR.Type.Struct,
    spec: [
      key: Stellar.XDR.Key32
    ]
end

defmodule Stellar.XDR.Curve25519Public do
  use XDR.Type.Struct,
    spec: [
      key: Stellar.XDR.Key32
    ]
end

defmodule Stellar.XDR.HmacSha256Key do
  use XDR.Type.Struct,
    spec: [
      key: Stellar.XDR.Key32
    ]
end

defmodule Stellar.XDR.HmacSha256Mac do
  use XDR.Type.Struct,
    spec: [
      mac: Stellar.XDR.Key32
    ]
end
