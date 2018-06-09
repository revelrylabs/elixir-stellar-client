defmodule Stellar.XDR.ASTProcessor do
  def process(ast) do
    ast
    |> IO.inspect(label: :before)
    |> do_process()
    |> IO.inspect(label: :after)
  end

  defp do_process([{:import, _} | rest]) do
    process(rest)
  end

  defp do_process([{:namespace, ast} | _rest]) do
    ast
    |> Enum.map(&process(&1))
  end

  defp do_process({:identifier, [identifier]}) do
    String.to_atom(identifier)
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

  defp do_process({:typedef, [type: "unsigned int", identifier: ["uint32"]]}) do
    XDR.Type.Uint
  end

  defp do_process({:typedef, [type: "int", identifier: ["int32"]]}) do
    XDR.Type.Int
  end

  defp do_process({:typedef, [type: "unsigned hyper", identifier: ["uint64"]]}) do
    XDR.Type.HyperUint
  end

  defp do_process({:typedef, [type: "hyper", identifier: ["int64"]]}) do
    XDR.Type.HyperInt
  end

  defp do_process({:typedef, [type: type, identifier: [aliasi]]}) do
    quote do
      alias String.to_atom(name), as: String.to_atom(aliasi)
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

  defp do_process(
         {:union, [{:identifier, [identifier]}, {:arg, [type: arg, identifier: _]} | cases]}
       ) do
    cases =
      cases
      |> Keyword.take([:case])
      |> Enum.map(&process(&1))

    quote do
      defmodule unquote(String.to_atom(identifier)) do
        use XDR.Type.Union,
            spec(
              switch: unquote(String.to_atom(arg)),
              cases: unquote(cases)
            )
      end
    end
  end

  defp do_process(
         {:case,
          [
            identifier: [case_identifier],
            type: type,
            identifier: [type_identifier]
          ]}
       ) do
    quote do
      {unquote(String.to_atom(case_identifier)), unquote(String.to_atom(type))}
    end
  end

  defp do_process(
         {:member,
          [
            identifier: [case_identifier],
            type: type,
            identifier: [type_identifier]
          ]}
       ) do
    quote do
      {unquote(String.to_atom(case_identifier)), unquote(String.to_atom(type))}
    end
  end

  defp do_process(value) when is_integer(value) do
    value
  end
end
