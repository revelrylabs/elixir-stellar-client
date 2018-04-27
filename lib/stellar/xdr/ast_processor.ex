defmodule Stellar.XDR.ASTProcessor do
  def process(ast) do
    ast
    |> IO.inspect()
    |> do_process()
  end

  defp do_process([{:import, _} | rest]) do
    process(rest)
  end

  defp do_process([{:namespace, ast} | _rest]) do
    ast
    |> Enum.map(&process(&1))
  end

  defp do_process({:typedef, [type: "opaque", identifier: [identifier, {:fixed_size, size}]]}) do
    quote do
      defmodule unquote(String.to_atom(identifier)) do
        use XDR.Type.FixedOpaque, len: unquote(size)
      end
    end
  end

  defp do_process({:typedef, [type: "opaque", identifier: [identifier, {:variable_size, []}]]}) do
    quote do
      defmodule unquote(String.to_atom(identifier)) do
        use XDR.Type.VariableOpaque
      end
    end
  end

  defp do_process({:typedef, [type: "opaque", identifier: [identifier, {:variable_size, size}]]}) do
    quote do
      defmodule unquote(String.to_atom(identifier)) do
        use XDR.Type.VariableOpaque, max_len: unquote(size)
      end
    end
  end

  defp do_process({:enum, [{:type, type} | pairs]}) do
    spec =
      Enum.map(Keyword.get_values(pairs, :pair), fn [{:identifier, [name]}, value] ->
        {String.to_atom(name), process(value)}
      end)

    quote do
      defmodule unquote(String.to_atom(type)) do
        use XDR.Type.Enum, spec: unquote(spec)
      end
    end
  end

  defp do_process({:union, [identifier: [identifier], arg: [type: arg, identifier: _] | cases]})

  defp do_process(
         {:case,
          [
            identifier: [case_identifier],
            type: type,
            identifier: [type_identifier]
          ]}
       ) do
  end

  defp do_process(value) do
    value
  end
end
