defmodule Killog.Modules.Equipment do
  defstruct id: "", name: "", faction: :undefined

  alias Killog.Data
  alias Killog.Event
  alias Killog.Error
  alias Killog.Id
  alias Killog.Util
  alias Killog.Modules.Equipment
  alias Killog.Modules.Faction

  def create(%{"name" => name, "faction" => faction_id} = input) when is_bitstring(name) and is_atom(faction_id) do
    case [Util.validate_name(name), Faction.select(faction_id)] do
      [{:error, e}, _] ->
        Error.new(e)
      [_, {:error, e}] ->
        Error.new(e)
      _ ->
        event = Event.new(input, [:create, :equipment])
        id = Id.hrid(:equipment, name)
        state = %Equipment{id: id, name: name, faction: faction_id}
        Data.save_state_with_log(id, state, event)
    end
  end
end
