defmodule Killog.Modules.Roster do
  defstruct id: "", name: "", faction: :undefined

  alias Killog.Data
  alias Killog.Event
  alias Killog.Id
  alias Killog.Modules.Roster

  @module_name :roster

  def create(%{"name" => name, "faction" => faction_id} = input) when is_bitstring(name) and is_atom(faction_id) do
    event = Event.new(input, [:create, @module_name])
    id = Id.hrid(@module_name, name)
    state = %Roster{id: id, name: name, faction: faction_id}
    Data.save_state_with_log(id, state, event)
  end
end
