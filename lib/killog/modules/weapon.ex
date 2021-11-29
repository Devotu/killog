defmodule Killog.Modules.Weapon do
  defstruct [
    id: "",
    name: "",
    attacks: 0,
    skill: 0,
    damage: {0, 0},
    special: [],
    critical: [],
    faction: :undefined
  ]

  @module_name :weapon

  alias Killog.Data
  alias Killog.Event
  alias Killog.Error
  alias Killog.Id
  alias Killog.Modules.Faction
  alias Killog.Modules.Weapon
  alias Killog.Util

  def create(%{"faction" => faction_id} = input) do
    case [validate_faction(faction_id), new(input)] do
      [{:error, e}, _] -> Error.new(e)
      [_, {:error, e}] -> Error.new(e)
      [{:ok}, state] ->
        event = Event.new(input, [:create, :tacop])
        Data.save_state_with_log(state.id, state, event)
    end
  end

  defp validate_faction(f) do
    case Faction.select(f) do
      {:error, e} -> {:error, e}
      _ -> {:ok}
    end
  end

  defp new(input) do
    case is_valid_input(input) do
      {:error, e} -> Error.new(e)
      _ ->
        %Weapon{
          id: Id.hrid(@module_name, input["name"]),
          name: input["name"],
          attacks: input["attacks"],
          skill: input["skill"],
          damage: {input["damage_normal"], input["damage_crit"]},
          special: input["special"],
          critical: input["critical"],
          faction: input["faction"],
        }
    end
  end

  defp is_valid_input(input) do
    input
    |> Util.validate("name", :string)
    |> Util.validate("attacks", :number)
    |> Util.validate("skill", :number)
    |> Util.validate("damage_normal", :number)
    |> Util.validate("damage_crit", :number)
    |> Util.validate("special", [:list, :string])
    |> Util.validate("critical", [:list, :string])
    |> Util.validate("faction", :atom)
  end
end
