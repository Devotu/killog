defmodule Killog.Modules.Fireteam do
  defstruct id: "", name: "", faction: :undefined

  alias Killog.Data
  alias Killog.Event
  alias Killog.Error
  alias Killog.Id
  alias Killog.Util
  alias Killog.Modules.Fireteam
  alias Killog.Modules.Faction

  @module_name :fireteam

  def create(%{"name" => name, "faction" => faction_id} = input) when is_bitstring(name) and is_atom(faction_id) do
    case [Util.validate_name(name), Faction.select(faction_id)] do
      [{:error, e}, _] ->
        Error.new(e)
      [_, {:error, e}] ->
        Error.new(e)
      _ ->
        event = Event.new(input, [:create, @module_name])
        id = Id.hrid(@module_name, name)
        state = %Fireteam{id: id, name: name, faction: faction_id}
        Data.save_state_with_log(id, state, event)
    end
  end

  def list_by_faction(%Faction{} = faction) do
    list()
    |> Enum.filter(fn ft -> faction.id == ft.faction end)
  end

  def list() do
    @module_name
    |> Data.list_ids()
    |> Enum.map(fn id -> Data.recall_state(id) end)
  end

  def select(selected) when is_bitstring(selected) do
    list()
    |> Enum.find(
      {:error, "fire team not found"},
      fn %Fireteam{id: id} -> selected == id end
    )
  end
end
