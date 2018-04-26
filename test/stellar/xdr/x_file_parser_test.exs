defmodule Stellar.XDR.XFileParser.Test do
  use ExUnit.Case
  alias Stellar.XDR.XFileParser

  test "parse namespace" do
    idl = """
    namespace stellar
    {
    }
    """

    assert {:ok, [{:namespace, [identifier: ["stellar"]]}], "", _, _, _} = XFileParser.parse(idl)
  end

  test "parse typedef" do
    idl = "typedef opaque Hash[32];"

    assert {:ok, [typedef: [type: "opaque", identifier: ["Hash", {:fixed_size, 32}]]], _, _, _, _} =
             XFileParser.parse(idl)
  end

  test "single line comment" do
    idl = """
    // typedef opaque Hash[32];
    """

    assert {:ok, [], _, _, _, _} = XFileParser.parse(idl)
  end

  test "multiline comment" do
    idl = """
    /*
    this is a comment
    */
    """

    assert {:ok, [], _, _, _, _} = XFileParser.parse(idl)
  end

  test "enum" do
    idl = """
    enum CryptoKeyType
    {
        KEY_TYPE_ED25519 = 0,
        KEY_TYPE_PRE_AUTH_TX = 1,
        KEY_TYPE_HASH_X = 2
    };
    """

    assert {:ok, _, _, _, _, _} = XFileParser.parse(idl)
  end

  test "struct" do
    idl = """
    struct Curve25519Secret
    {
            opaque key[32];
    };
    """

    assert {:ok, _, _, _, _, _} = XFileParser.parse(idl)
  end

  test "struct with inline union" do
    idl = """
    struct AccountEntry
    {
    AccountID accountID;      // master public key for this account
    int64 balance;            // in stroops
    SequenceNumber seqNum;    // last sequence number used for this account
    uint32 numSubEntries;     // number of sub-entries this account has
                              // drives the reserve
    AccountID* inflationDest; // Account to vote for during inflation
    uint32 flags;             // see AccountFlags

    string32 homeDomain; // can be used for reverse federation and memo lookup

    // fields used for signatures
    // thresholds stores unsigned bytes: [weight of master|low|medium|high]
    Thresholds thresholds;

    Signer signers<20>; // possible signers for this account

    // reserved for future use
    union switch (int v)
    {
    case 0:
        void;
    }
    ext;
    };
    """

    assert {:ok, _, _, _, _, _} = XFileParser.parse(idl)
  end

  test "union" do
    idl = """
    union PublicKey switch (PublicKeyType type)
    {
    case PUBLIC_KEY_TYPE_ED25519:
    uint256 ed25519;
    };
    """

    assert {:ok, _, _, _, _, _} = XFileParser.parse(idl)
  end

  test "union with inline struct" do
    idl = """
    union Asset switch (AssetType type)
    {
    case ASSET_TYPE_NATIVE: // Not credit
        void;

    case ASSET_TYPE_CREDIT_ALPHANUM4:
        struct
        {
            opaque assetCode[4]; // 1 to 4 characters
            AccountID issuer;
        } alphaNum4;

    case ASSET_TYPE_CREDIT_ALPHANUM12:
        struct
        {
            opaque assetCode[12]; // 5 to 12 characters
            AccountID issuer;
        } alphaNum12;

        // add other asset types here in the future
    };
    """

    assert {:ok, _, _, _, _, _} = XFileParser.parse(idl)
  end

  test "import" do
    idl = """
    %#include "xdr/Stellar-types.h"
    """

    assert {:ok, _, _, _, _, _} = XFileParser.parse(idl)
  end

  test "Stellar-types" do
    result =
      [:code.priv_dir(:stellar), "xdr", "Stellar-types.x"]
      |> Path.join()
      |> XFileParser.parse_from_path()

    assert {:ok, _, "", %{}, _, _} = result
  end

  test "Stellar-ledger-entries" do
    result =
      [:code.priv_dir(:stellar), "xdr", "Stellar-ledger-entries.x"]
      |> Path.join()
      |> XFileParser.parse_from_path()

    assert {:ok, _, "", %{}, _, _} = result
  end

  test "Stellar-transaction" do
    result =
      [:code.priv_dir(:stellar), "xdr", "Stellar-transaction.x"]
      |> Path.join()
      |> XFileParser.parse_from_path()

    assert {:ok, _, "", %{}, _, _} = result
  end
end
