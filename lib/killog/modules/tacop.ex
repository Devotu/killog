defmodule Killog.Modules.Tacop do
  defstruct id: "", name: "", archetype: :undefined

  alias Killog.Data
  alias Killog.Event
  alias Killog.Id
  alias Killog.Modules.Tacop

  @archetypes [
    {:security, "Security"},
    {:seek, "Seek and Destroy"},
  ]

  def archetypes() do
    @archetypes
  end

  def create(%{"name" => name, "archetype" => archetype_id} = input) when is_bitstring(name) and is_bitstring(archetype_id) do
    case select_archetype(archetype_id) do
      {:error, e} -> {:error, e}
      {archetype_id, _name} ->
        event = Event.new(input, [:create, :tacop])
        id = Id.hrid(:tacop, name)
        state = %Tacop{id: id, name: name, archetype: archetype_id}
        Data.save_state_with_log(id, state, event)
    end
  end

  def select_archetype(selected_archetype) when is_bitstring(selected_archetype) do
    Tacop.archetypes()
    |> Enum.find(
      {:error, "archetype not found"},
      fn {t, _name} -> selected_archetype == Atom.to_string(t) end
    )
  end
end
