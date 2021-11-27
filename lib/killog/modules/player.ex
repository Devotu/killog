defmodule Killog.Modules.Player do
  defstruct id: "", name: ""

  alias Killog.Data
  alias Killog.Event
  alias Killog.Id
  alias Killog.Modules.Player

  def create(%{"name" => name} = input) when is_bitstring(name) do
    event = Event.new(input, [:create, :player])
    id = Id.hrid(:player, name)
    state = %Player{id: id, name: name}
    Data.save_state_with_log(id, state, event)
  end
end
