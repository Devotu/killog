defmodule KillogWeb.EquipmentLive do
  use KillogWeb, :live_view

  alias Killog.Modules.Equipment
  alias Killog.Modules.Faction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, factions: Faction.factions)}
  end

  @impl true
  def handle_event("add", %{"name" => name, "faction" => faction} = input, socket) do
    clean_input = input
    |> Map.put("faction", Faction.select(faction).id)

    case Equipment.create(clean_input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
    end
  end
end
