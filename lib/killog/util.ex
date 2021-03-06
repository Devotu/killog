defmodule Killog.Util do

  alias Killog.Error

  def value_inputs_to_numbers(input) when is_map(input) do
    input
    |> Enum.reduce(%{}, fn {k, v}, a -> Map.put(a, k, prefer_number(v)) end)
  end

  def prefer_number(v) when is_bitstring(v) do
    case Integer.parse(v) do
      :error -> v
      {x, _} -> x
    end
  end
  def prefer_number(v), do: v

  def inluding_keys?(map, expected_keys) when is_map(map) and is_list(expected_keys) do
    expected_keys
    |> Enum.count(fn k -> Enum.member?(Map.keys(map), k) end)
    |> then(fn x -> x == Enum.count(expected_keys) end)
  end

  defp has_key(map, key) do
    Enum.member? Map.keys(map), key
  end

  def validate({:error, e}, _, _), do: Error.new(e)
  def validate(map, key, :number) when is_map(map), do: validate_number_present(map, key)
  def validate(map, key, :string) when is_map(map), do: validate_string_present(map, key)
  def validate(map, key, :atom) when is_map(map), do: validate_atom_present(map, key)
  def validate(map, key, [:list, type]) when is_map(map), do: validate_list_present(map, key, type)

  defp validate_number_present(map, key) do
    case [has_key(map, key), is_number(map[key])] do
      [false, _] -> Error.new "key #{key} not found"
      [_, false] -> Error.new "input #{key} not a number"
      [true, true] -> map
    end
  end

  defp validate_string_present(map, key) do
    case [has_key(map, key), is_bitstring(map[key])] do
      [false, _] -> Error.new "key #{key} not found"
      [_, false] -> Error.new "input #{key} not a string"
      [true, true] -> map
    end
  end

  defp validate_atom_present(map, key) do
    case [has_key(map, key), is_atom(map[key])] do
      [false, _] -> Error.new "key #{key} not found"
      [_, false] -> Error.new "input #{key} not an atom"
      [true, true] -> map
    end
  end

  defp validate_list_present(map, key, type) when is_atom(type) do
    case [has_key(map, key), all_of_type?(map[key], type)] do
      [false, _] -> Error.new "key #{key} not found"
      [_, false] -> Error.new "input #{key} contains other than #{Atom.to_string(type)}"
      [true, true] -> map
    end
  end

  defp all_of_type?(nil, _type), do: false
  defp all_of_type?(list, type) when is_list(list) and is_atom(type) do
    list
    |> Enum.count(fn v -> !is_type?(v, type) end)
    |> then(&(&1 == 0))
  end

  defp is_type?(value, :number) when is_number(value), do: true
  defp is_type?(_value, :number), do: false

  defp is_type?(value, :string) when is_bitstring(value), do: true
  defp is_type?(_value, :string), do: false

  defp is_type?(value, :atom) when is_atom(value), do: true
  defp is_type?(_value, :atom), do: false

  def validate_name(term) when is_bitstring(term) do
    case [is_less_than_50?(term), only_valid_characters?(term)] do
      [false, _] ->
        Error.new("name to long")
      [_, false] ->
        Error.new("name includes invalid characters")
      _ ->
        {:ok}
    end
  end

  defp is_less_than_50?(term) when is_bitstring(term) do
    String.length(term) < 50
  end

  #just to get rid of obviously errorus stuff
  defp only_valid_characters?(term) when is_bitstring(term) do
    term
    |> String.contains?(["(", ")", ":", ";", "{", "}", "+", "!", "?", "'", "/", "\\"])
    |> then(&(!&1))
  end

  def switch_list(item, from_list, to_list) do
    from_list = from_list
    |> Enum.filter(fn i -> i != item end)

    to_list = to_list ++ [item]
    |> Enum.uniq()

    {from_list, to_list}
  end

  def struct_to_pretty(s) when is_struct(s) do
    Kernel.inspect(s) |> pretty()
  end
  def struct_to_pretty(s) do
    IO.inspect Kernel.inspect(s), label: "Helpers - struct_to_pretty - not a struct"
  end

  defp pretty(s) when is_bitstring(s) do
    pretty(0, s)
  end
  defp pretty(_d, "") do
    ""
  end
  defp pretty(d, "{" <> rem) do
    dn = d + 1
    "{" <> "\n" <> tabs(dn) <> pretty(dn, String.trim(rem))
  end
  defp pretty(d, "}" <> rem) do
    dn = d - 1
    "\n" <> tabs(dn) <> "}" <> pretty(dn, String.trim(rem))
  end
  defp pretty(d, "[]" <> rem) do
    "[]" <> pretty(d, String.trim(rem))
  end
  defp pretty(d, "[" <> rem) do
    dn = d + 1
    "[" <> "\n" <> tabs(dn) <> pretty(dn, String.trim(rem))
  end
  defp pretty(d, "]" <> rem) do
    dn = d - 1
    "\n" <> tabs(dn) <> "]" <> pretty(dn, String.trim(rem))
  end
  defp pretty(d, "," <> rem) do
    "," <> "\n" <> tabs(d) <> pretty(d, String.trim(rem))
  end
  defp pretty(d, s) do
    {c, rem} = String.split_at(s, 1)
    c <> pretty(d, rem)
  end
  defp tabs(n) do
    String.duplicate("\t", n)
  end
end
