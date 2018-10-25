defmodule Stellar.XDR.Types.Overlay do
  alias XDR.Type.{
    Enum,
    FixedOpaque,
    Struct,
    Union,
    VariableArray,
    Void
  }

  alias Stellar.XDR.Types.{
    Curve25519Public,
    Hash,
    HmacSha256Mac,
    Int32,
    NodeID,
    SCP,
    Signature,
    Transaction,
    UInt32,
    UInt64,
    UInt256
  }

  alias Transaction.{
    TransactionEnvelope,
    TransactionSet
  }

  alias SCP.{
    SCPQuorumSet,
    SCPEnvelope
  }

  defmodule ErrorCode do
    use Enum,
      ERR_MISC: 0,
      ERR_DATA: 1,
      ERR_CONF: 2,
      ERR_AUTH: 3,
      ERR_LOAD: 4
  end

  defmodule String100 do
    use XDR.Type.String, max_len: 100
  end

  defmodule Error do
    use Struct,
      code: ErrorCode,
      msg: String100
  end

  defmodule AuthCert do
    use Struct,
      pubkey: Curve25519Public,
      expiration: UInt64,
      sig: Signature
  end

  defmodule Hello do
    use Struct,
      ledgerVersion: UInt32,
      overlayVersion: UInt32,
      overMinVersion: UInt32,
      networkID: Hash,
      versionStr: String100,
      listeningPort: Int32,
      peerID: NodeID,
      cert: AuthCert,
      nonce: UInt256
  end

  defmodule Auth do
    use Struct,
      unused: Int32
  end

  defmodule IPAddrType do
    use Enum,
      IPv4: 0,
      IPv6: 1
  end

  defmodule IPv4 do
    use FixedOpaque, len: 4
  end

  defmodule IPv6 do
    use FixedOpaque, len: 16
  end

  defmodule IP do
    use Union,
      switch: IPAddrType,
      cases: [
        IPv4: IPv4,
        IPv6: IPv6
      ]
  end

  defmodule PeerAddress do
    use Struct,
      ip: IP,
      port: UInt32,
      numFailures: UInt32
  end

  defmodule MessageType do
    use Enum,
      ERROR_MSG: 0,
      AUTH: 2,
      DONT_HAVE: 3,
      GET_PEERS: 4,
      PEERS: 5,
      GET_TX_SET: 6,
      TX_SET: 7,
      TRANSACTION: 8,
      GET_SCP_QUORUMSET: 9,
      SCP_QUORUMSET: 10,
      SCP_MESSAGE: 11,
      GET_SCP_STATE: 12,
      HELLO: 13
  end

  defmodule DontHave do
    use Struct,
      type: MessageType,
      reqHash: UInt256
  end

  defmodule Peers do
    use VariableArray, max_len: 100, type: PeerAddress
  end

  defmodule StellarMessage do
    use Union,
      switch: MessageType,
      cases: [
        ERROR_MSG: Error,
        AUTH: Auth,
        DONT_HAVE: DontHave,
        GET_PEERS: Void,
        PEERS: Peers,
        GET_TX_SET: UInt256,
        TX_SET: TransactionSet,
        TRANSACTION: TransactionEnvelope,
        GET_SCP_QUORUMSET: UInt256,
        SCP_QUORUMSET: SCPQuorumSet,
        SCP_MESSAGE: SCPEnvelope,
        GET_SCP_STATE: UInt32,
        HELLO: Hello
      ]
  end

  defmodule AuthenticatedMessageV0 do
    use Struct,
      sequence: UInt64,
      message: StellarMessage,
      mac: HmacSha256Mac
  end

  defmodule AuthenticatedMessage do
    use Union,
      switch: UInt32,
      cases: [
        {0, AuthenticatedMessageV0}
      ]
  end
end
