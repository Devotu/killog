defmodule Killog.Modules.Faction do
  defstruct id: :undefined, name: ""

  alias Killog.Modules.Faction

  @factions [
    {:marines, "Space Marines"},
    {:chaos, "Chaos Marines"},
    {:orc, "Greenskins"},
  ]

  def factions() do
    @factions
    |> Enum.map(&new/1)
  end

  #actual cannot be defined in same as struct defining module
  defp new({id, name}) do
    %Faction{id: id, name: name}
  end

  def select(selected) when is_atom(selected) do
    factions()
    |> Enum.find(
      {:error, "faction not found"},
      fn %Faction{id: id} -> selected == id end
    )
  end
  def select(selected) when is_bitstring(selected) do
    factions()
    |> Enum.find(
      {:error, "faction not found"},
      fn %Faction{id: id} -> selected == Atom.to_string(id) end
    )
  end
end
