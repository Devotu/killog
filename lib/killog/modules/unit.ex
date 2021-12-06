defmodule Killog.Modules.Unit do
  defstruct [
    id: "",
    name: "",
    movement: 0,
    action_points: 0,
    group_activation: 0,
    defence: 0,
    save: 0,
    wounds: 0,
    abilities: [],
    actions: [],
    weapons: [],
    fireteam: :undefined
  ]

  alias Killog.Data
  alias Killog.Event
  alias Killog.Error
  alias Killog.Id
  alias Killog.Util
  alias Killog.Modules.Unit

  @module_name :unit

  def create(%{"name" => name, "fireteam" => fireteam_id} = input) when is_bitstring(name) and is_atom(fireteam_id) do
    case Util.validate_name(name) do
      {:error, e} ->
        Error.new(e)
      _ ->
        event = Event.new(input, [:create, @module_name])
        id = Id.hrid(@module_name, name)
        state = %Unit{id: id, name: name, fireteam: fireteam_id}
        Data.save_state_with_log(id, state, event)
    end
  end
end
