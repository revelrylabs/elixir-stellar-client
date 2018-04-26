defmodule Stellar.XDR.XFileParser do
  import NimbleParsec

  @moduledoc """
  A parser for parsing the .x files that hold the IDL for
  Stellar's XDR types found [here](https://github.com/stellar/js-stellar-base/tree/master/xdr)
  """
  defparsecp(:newline, string("\n") |> times(min: 1))

  defparsecp(
    :single_line_comment,
    string("//")
    |> utf8_string([not: ?\n], min: 1)
    |> parsec(:newline)
  )

  defp not_eoc(<<"*/", _::binary>>, context, _, _), do: {:halt, context}
  defp not_eoc(_, context, _, _), do: {:cont, context}

  defparsecp(
    :multi_line_comment,
    string("/*")
    |> repeat_while(utf8_char([]), {:not_eoc, []})
    |> string("*/")
    |> ignore(optional(parsec(:newline)))
  )

  ignoreables =
    choice([
      string("\t"),
      string(" "),
      string("\n"),
      parsec(:single_line_comment),
      parsec(:multi_line_comment)
    ])
    |> times(min: 1)
    |> ignore

  defp parse_integer(int), do: int |> Integer.parse() |> elem(0)

  defparsecp(
    :integer,
    optional(string("-"))
    |> utf8_string([?0..?9], min: 1)
    |> reduce({Enum, :join, []})
    |> map({:parse_integer, []})
  )

  defp parse_octet(int), do: int |> Integer.parse(8) |> elem(0)

  defparsecp(
    :octet,
    ignore(string("0x"))
    |> utf8_string([?0..?9], min: 1)
    |> map({:parse_octet, []})
  )

  defparsecp(
    :number,
    choice([
      parsec(:octet),
      parsec(:integer)
    ])
  )

  defparsecp(
    :fixed_size,
    ignore(string("["))
    |> parsec(:number)
    |> ignore(string("]"))
    |> unwrap_and_tag(:fixed_size)
  )

  defparsecp(
    :unknown_variable_size,
    ignore(string("<"))
    |> ignore(string(">"))
    |> tag(:variable_size)
  )

  defparsecp(
    :variable_size,
    ignore(string("<"))
    |> parsec(:number)
    |> ignore(string(">"))
    |> unwrap_and_tag(:variable_size)
  )

  defparsecp(
    :identifier,
    utf8_string([?0..?9, ?a..?z, ?A..?Z, ?_], min: 1)
    |> optional(
      choice([
        parsec(:fixed_size),
        parsec(:variable_size),
        parsec(:unknown_variable_size)
      ])
    )
    |> tag(:identifier)
  )

  defparsecp(
    :type,
    choice([
      string("unsigned int"),
      string("unsigned hyper"),
      utf8_string([?0..?9, ?a..?z, ?A..?Z, ?[, ?], ?*], min: 1)
    ])
    |> unwrap_and_tag(:type)
  )

  defparsecp(
    :def,
    parsec(:type)
    |> optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
  )

  defparsecp(
    :typedef,
    ignore(string("typedef"))
    |> optional(ignoreables)
    |> parsec(:def)
    |> tag(:typedef)
  )

  defparsecp(
    :enum_pair,
    optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignoreables)
    |> ignore(string("="))
    |> optional(ignoreables)
    |> choice([
      parsec(:number),
      parsec(:identifier)
    ])
    |> optional(ignore(string(",")))
    |> optional(ignoreables)
    |> tag(:pair)
  )

  defparsecp(
    :enum,
    ignore(string("enum"))
    |> optional(ignoreables)
    |> parsec(:type)
    |> optional(ignoreables)
    |> ignore(string("{"))
    |> optional(ignoreables)
    |> repeat_until(parsec(:enum_pair), [string("}")])
    |> ignore(string("}"))
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:enum)
  )

  defparsecp(
    :member,
    optional(ignoreables)
    |> parsec(:def)
    |> optional(ignoreables)
    |> tag(:member)
  )

  defparsecp(
    :inline_union_member,
    ignore(string("union"))
    |> optional(ignoreables)
    |> ignore(string("switch"))
    |> optional(ignoreables)
    |> parsec(:union_arg)
    |> optional(ignoreables)
    |> ignore(string("{"))
    |> optional(ignoreables)
    |> repeat_until(choice([parsec(:case), parsec(:default)]), [string("}")])
    |> ignore(string("}"))
    |> optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:union_member)
  )

  defparsecp(
    :struct,
    ignore(string("struct"))
    |> optional(ignoreables)
    |> parsec(:type)
    |> optional(ignoreables)
    |> ignore(string("{"))
    |> optional(ignoreables)
    |> repeat_until(
      choice([parsec(:inline_struct), parsec(:inline_union_member), parsec(:member)]),
      [string("}")]
    )
    |> ignore(string("}"))
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:struct)
  )

  defparsecp(
    :inline_struct,
    ignore(string("struct"))
    |> optional(ignoreables)
    |> ignore(string("{"))
    |> optional(ignoreables)
    |> repeat_until(choice([parsec(:inline_union_member), parsec(:member)]), [string("}")])
    |> ignore(string("}"))
    |> optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:struct_member)
  )

  defparsecp(
    :case,
    ignore(string("case"))
    |> optional(ignoreables)
    |> choice([parsec(:number), parsec(:identifier)])
    |> ignore(string(":"))
    |> optional(ignoreables)
    |> choice([parsec(:inline_union_member), parsec(:inline_struct), parsec(:def), parsec(:type)])
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:case)
  )

  defparsecp(
    :default,
    ignore(string("default"))
    |> ignore(string(":"))
    |> optional(ignoreables)
    |> choice([parsec(:inline_struct), parsec(:def), parsec(:type)])
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:default)
  )

  defparsecp(
    :union_arg,
    ignore(string("("))
    |> optional(ignoreables)
    |> parsec(:type)
    |> optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignoreables)
    |> ignore(string(")"))
    |> tag(:arg)
  )

  defparsecp(
    :union,
    ignore(string("union"))
    |> optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignoreables)
    |> ignore(string("switch"))
    |> optional(ignoreables)
    |> parsec(:union_arg)
    |> optional(ignoreables)
    |> ignore(string("{"))
    |> optional(ignoreables)
    |> repeat_until(choice([parsec(:case), parsec(:default)]), [string("}")])
    |> ignore(string("}"))
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:union)
  )

  defparsecp(
    :include,
    ignore(string("%#include"))
    |> optional(ignoreables)
    |> ignore(string("\""))
    |> repeat_until(utf8_string([not: ?"], min: 1), [string("\"")])
    |> ignore(string("\""))
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> unwrap_and_tag(:include)
  )

  defparsecp(
    :namespace,
    ignore(string("namespace"))
    |> optional(ignoreables)
    |> parsec(:identifier)
    |> optional(ignoreables)
    |> ignore(string("{"))
    |> optional(ignoreables)
    |> repeat_until(parsec(:parse), [string("}")])
    |> ignore(string("}"))
    |> optional(ignoreables)
    |> optional(ignore(string(";")))
    |> optional(ignoreables)
    |> tag(:namespace)
  )

  parser =
    choice([
      parsec(:newline),
      parsec(:include),
      parsec(:namespace),
      parsec(:typedef),
      parsec(:enum),
      parsec(:struct),
      parsec(:union),
      ignore(parsec(:single_line_comment)),
      ignore(parsec(:multi_line_comment))
    ])
    |> times(min: 1)

  defparsec(:parse, parser)

  def parse_from_path(path) do
    path
    |> File.read!()
    |> parse()
  end
end
