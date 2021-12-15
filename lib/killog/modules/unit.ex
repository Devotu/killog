defmodule Killog.Modules.Unit do
  defstruct [
    id: "",
    name: "",
    movement: 0,
    action_point_limit: 0,
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

  def create(%{"name" => name, "fireteam" => fireteam_id} = input) when is_bitstring(name) and is_bitstring(fireteam_id) do
    case Util.validate_name(name) do
      {:error, e} ->
        Error.new(e)
      _ ->
        event = Event.new(input, [:create, @module_name])
        id = Id.hrid(@module_name, name)
        case new(input) do
          {:error, e} -> Error.new(e)
          state -> Data.save_state_with_log(id, state, event)
        end
    end
  end

  #Names in input taken from data cards
  defp new(input) do
    IO.inspect input, label: "input new unit"
    case is_valid_input(input) do
      {:error, e} -> Error.new(e)
      _ ->
        %Unit{
          id: Id.hrid(@module_name, input["name"]),
          name: input["name"],
          movement: input["m"],
          action_point_limit: input["apl"],
          group_activation: input["ga"],
          defence: input["df"],
          save: input["sv"],
          wounds: input["w"],
          abilities: input["abilities"],
          actions: input["actions"],
          fireteam: input["fireteam"],
        }
    end
  end

  defp is_valid_input(input) do
    input
    |> Util.validate("name", :string)
    |> Util.validate("m", :number)
    |> Util.validate("apl", :number)
    |> Util.validate("ga", :number)
    |> Util.validate("df", :number)
    |> Util.validate("sv", :number)
    |> Util.validate("w", :number)
    |> Util.validate("weapons", [:list, :string])
    |> Util.validate("abilities", [:list, :string])
    |> Util.validate("actions", [:list, :string])
    |> Util.validate("fireteam", :string)
  end
end
