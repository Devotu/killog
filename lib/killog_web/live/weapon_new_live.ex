defmodule KillogWeb.WeaponNewLive do
  use KillogWeb, :live_view

  alias Killog.Modules.Faction
  alias Killog.Modules.Weapon
  alias Killog.Util

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, factions: Faction.factions())}
  end

  @impl true
  def handle_event("add", %{"name" => name, "faction" => faction} = input, socket) do
    clean_input = input
    |> Map.put("special", [])
    |> Map.put("critical", [])
    |> Map.put("faction", Faction.select(faction).id)
    |> Util.value_inputs_to_numbers()

    case Weapon.create(clean_input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
    end
  end
end
