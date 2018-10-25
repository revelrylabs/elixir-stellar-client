alias Stellar.XDR.Types

ledger_header_data = "AAAACcks7SEfHkDuhjvmvF+gKaINj3tDOa5WM4nJwaN5sMyn1D/Cw44W08u6FCpdM/FQHQ4aeskY9MAlKlq6A/xO1QgAAAAAW2I60gAAAAAAAAAAIlFSBMfJDmczeRK3yru+7i4ES6ft6COlHIPOJfE8FTaOu1onEG4cVZMH2qvVXAMaAjFjS2Qz7RANhJ/R0CQQMACdlSEOc/6udibiZAA/v9/PJqaoAAAA1gAAAAAACJANAAAAZABMS0AAAAAyKM0WUC2QMHCSFH/B9hVSscs79BALzSpdRqiLtUxd7Pio/PUHmpYDSdUYvqfv5dJ2Y68U/0aj6MiccIg/RjGiP9WP/ufHKMzernlVpSy2Nh2GFKq7QlkwfqBbXFvCMpcNnLfxQtZ/DqPjHr85qQBYJwxJfEmU2jRhLpMSgIFiFSIAAAAA"

ledger_header =
  ledger_header_data
  |> Base.decode64!
  |> IO.inspect(label: :ledger_header_binary)
  |> Types.Ledger.LedgerHeader.decode
  |> IO.inspect(label: :ledger_header)
