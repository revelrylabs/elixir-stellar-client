defmodule Stellar.XDR.TypeBuilder do
  alias Stellar.XDR.{XFileParser, ASTProcessor}

  defmacro __before_compile__(_) do
    values = build()

    quote do
      (unquote_splicing(values))
    end
  end

  def build() do
    Enum.map(get_x_file_paths(), &process_x_file_path(&1))
  end

  defp get_x_file_paths() do
    path = [:code.priv_dir(:stellar), "xdr"]

    files = [
      "Stellar-types.x"
      # "Stellar-ledger-entries.x",
      # "Stellar-transaction.x",
      # "Stellar-ledger.x",
      # "Stellar-overlay.x",
      # "Stellar-SCP.x"
    ]

    Enum.map(files, fn file -> Path.join(path ++ [file]) end)
  end

  def process_x_file_path(path) do
    {:ok, ast, _, _, _, _} = XFileParser.parse_from_path(path)

    ASTProcessor.process(ast)
  end
end
