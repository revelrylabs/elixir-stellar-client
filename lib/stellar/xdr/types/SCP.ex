defmodule Stellar.XDR.Types.SCP do
  alias XDR.Type.{
    Enum,
    Optional,
    Struct,
    Union,
    VariableArray,
    VariableOpaque
  }

  alias Stellar.XDR.Types.{
    Hash,
    NodeID,
    PublicKey,
    Signature,
    UInt32,
    UInt64
  }

  defmodule Value do
    use VariableOpaque
  end

  defmodule Values do
    use VariableArray, type: Value
  end

  defmodule SCPBallot do
    use Struct,
      counter: UInt32,
      value: Value
  end

  defmodule SCPNomination do
    use Struct,
      quorumSetHash: Hash,
      votes: Values,
      accepted: Values
  end

  defmodule SCPStatementType do
    use Enum,
      SCP_ST_PREPARE: 0,
      SCP_ST_CONFIRM: 1,
      SCP_ST_EXTERNALIZE: 2,
      SCP_ST_NOMINATE: 3
  end

  defmodule OptionalSCPBallot do
    use Optional, for: SCPBallot
  end

  defmodule SCPStatementPrepare do
    use Struct,
      quorumSetHash: Hash,
      ballot: SCPBallot,
      prepared: OptionalSCPBallot,
      preparedPrime: OptionalSCPBallot,
      nC: UInt32,
      nH: UInt32
  end

  defmodule SCPStatementConfirm do
    use Struct,
      ballot: SCPBallot,
      nPrepared: UInt32,
      nCommit: UInt32,
      nH: UInt32,
      quorumSetHash: Hash
  end

  defmodule SCPStatementExternalize do
    use Struct,
      commit: SCPBallot,
      nH: UInt32,
      commitQuorumSetHash: Hash
  end

  defmodule SCPStatementPledge do
    use Union,
      switch: SCPStatementType,
      cases: [
        SCP_ST_PREPARE: SCPStatementPrepare,
        SCP_ST_CONFIRM: SCPStatementConfirm,
        SCP_ST_EXTERNALIZE: SCPStatementExternalize,
        SCP_ST_NOMINATE: SCPNomination
      ]
  end

  defmodule SCPStatement do
    use Struct,
      nodeID: NodeID,
      slotIndex: UInt64,
      pledges: SCPStatementPledge
  end

  defmodule SCPEnvelope do
    use Struct,
      statement: SCPStatement,
      signature: Signature
  end

  defmodule Validators do
    use VariableArray, type: PublicKey
  end

  defmodule SCPQuorumSets do
    use VariableArray, type: SCPQuorumSet
  end

  defmodule SCPQuorumSet do
    use Struct,
      threshold: UInt32,
      validators: Validators,
      innerSets: SCPQuorumSets
  end
end
