defmodule KillogWeb.UnitLive do
  use KillogWeb, :live_view

  alias Killog.Modules.Faction
  alias Killog.Modules.Fireteam
  alias Killog.Modules.Unit
  alias Killog.Modules.Weapon
  alias Killog.Util

  @impl true
  def mount(_params, _session, socket) do
    faction = Faction.factions() |> List.first()
    fireteams = Fireteam.select_by_faction(faction)
    weapons = Weapon.select_by_faction(faction)
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

    available_fireteams = Fireteam.select_by_faction(faction)
    fireteam = available_fireteams
    |> Enum.find(nil, fn t -> t.id == fireteam_id end)
    remaining_fireteams = available_fireteams
    |> Enum.filter(fn t -> t.id != fireteam_id end)

    available_weapons = Weapon.select_by_faction(faction)

    {:noreply, assign(socket,
      faction: faction,
      available_fireteams: remaining_fireteams,
      fireteam: fireteam,
      available_weapons: available_weapons,
      weapons: []
      )}
  end

  def handle_event("add_weapon", %{"value" => weapon_id}, socket) do
    weapon = Weapon.select_by_id(weapon_id)
    {available_weapons, used_weapons} = Util.switch_list(weapon, socket.assigns.available_weapons, socket.assigns.weapons)

    {:noreply, assign(socket,
      available_weapons: available_weapons,
      weapons: used_weapons
      )}
  end

  def handle_event("remove_weapon", %{"value" => weapon_id}, socket) do
    weapon = Weapon.select_by_id(weapon_id)
    {used_weapons, available_weapons} = Util.switch_list(weapon, socket.assigns.weapons, socket.assigns.available_weapons)

    {:noreply, assign(socket,
      available_weapons: available_weapons,
      weapons: used_weapons
      )}
  end

  @impl true
  def handle_event("add", %{"name" => name, "faction" => faction} = input, socket) do
    clean_input = input
    |> Map.put("special", [])
    |> Map.put("critical", [])
    |> Map.put("faction", Faction.select(faction).id)
    |> Util.value_inputs_to_numbers()

    case Unit.create(clean_input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
    end
  end
end
