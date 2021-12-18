defmodule Killog.Id do
  defstruct id: ""

  alias Killog.Error
  alias Killog.Util

  def hrid(namespace, base) when is_atom(namespace) do
    case Util.validate_name(base) do
      {:error, e} ->
        Error.new("invalid base name: '#{e}'")
      _ ->
        space = namespace
        |> Atom.to_string()

        item = base
        |> String.replace(" ", "_")
        |> String.downcase()

        "#{space}_#{item}_#{guid()}"
    end
  end

  def guid() do
    [
      "cat", "hat", "cow", "sit", "rug",
      "hug", "bot", "pot", "bat", "fat",
      "car", "far", "bar", "foo", "how",
      "jar", "par", "sub", "hub", "cub",
      "hop", "tap", "fit", "hit", "big",
      "rot", "wit", "met", "pal", "lap",
      "inn", "cap", "run", "bun", "ill",
      "gap", "kit", "gin", "den", "zap"
    ]
    |> Enum.take_random(2)
    |> Enum.concat([Enum.random(10..99) |> Integer.to_string()])
    |> Enum.concat([Enum.random(10..99) |> Integer.to_string()])
    |> Enum.join("_")
  end

  def extract_type(id) when is_bitstring(id) do
    id
    |> String.split("_")
    |> List.first()
  end
end
