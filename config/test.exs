use Mix.Config

config :stellar, network: :test

# This account ONLY exists on the testnet and is ONLY used in the test suite
config :stellar, :test_account,
  public_key: "GAW7DAQWCZS7OKF3KTLDNW3BBRUQOQKMOGPM33SNV5XW6FYVQ2URI7B4",
  secret: "SCTQEYOV2FBROO76J2CRBBMJQVNL67OLID74JFC4TSI6QAQ6JLUUFLLA"

if File.exists?(Path.join([__DIR__, "test.secret.exs"])) do
  import_config "test.secret.exs"
end
