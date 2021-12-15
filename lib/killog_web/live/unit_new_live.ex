defmodule KillogWeb.UnitNewLive do
  use KillogWeb, :live_view

  alias Killog.Modules.Faction
  alias Killog.Modules.Fireteam
  alias Killog.Modules.Unit
  alias Killog.Modules.Weapon
  alias Killog.Util

  @impl true
  def mount(_params, _session, socket) do
    faction = Faction.factions() |> List.first()
    fireteams = Fireteam.list_by_faction(faction)
    weapons = Weapon.list_by_faction(faction)
    {:ok, assign(socket,
      faction: faction,
      factions: Faction.factions(),
      available_fireteams: fireteams,
      fireteam: nil,
      available_weapons: weapons,
      weapons: []
    )}
  end

  def handle_event("update", %{"faction" => faction_id, "fireteam" => fireteam_id}, socket) do
    faction = Faction.select(faction_id)

    available_fireteams = Fireteam.list_by_faction(faction)
    fireteam = available_fireteams
    |> Enum.find(nil, fn t -> t.id == fireteam_id end)
    remaining_fireteams = available_fireteams
    |> Enum.filter(fn t -> t.id != fireteam_id end)

    available_weapons = Weapon.list_by_faction(faction)

    {:noreply, assign(socket,
      faction: faction,
      available_fireteams: remaining_fireteams,
      fireteam: fireteam,
      available_weapons: available_weapons,
      weapons: []
      )}
  end

  @impl true
  def handle_event("add", %{"name" => name, "fireteam" => fireteam} = input, socket) do
    clean_input = input
    |> Map.put("weapons", [])
    |> Map.put("abilities", [])
    |> Map.put("actions", [])
    |> Map.put("fireteam", Fireteam.select(fireteam).id)
    |> Util.value_inputs_to_numbers()

    case Unit.create(clean_input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
    end
  end
end
