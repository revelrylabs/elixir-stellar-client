defmodule Stellar.XDR.TypeBuilder do
  alias Stellar.XDR.XFileParser

  defmacro __before_compile__(_) do
    quote do
      defmodule Foo do
        def hello() do
          "hi"
        end
      end
    end
  end

  def build() do
    xdr_file_paths = get_x_file_paths()
    Enum.each(xdr_file_paths, &process_x_file_path(&1))
  end

  defp get_x_file_paths() do
    [:code.priv_dir(:stellar), "xdr", "*.x"]
    |> Path.join()
    |> Path.wildcard()
    |> Enum.reverse()
  end

  def process_x_file_path(path) do
    path
    |> XFileParser.parse_from_path()
  end
end
