defmodule KillogWeb.RosterNewLive do
  use KillogWeb, :live_view

  alias Killog.Modules.Faction
  alias Killog.Modules.Roster
  alias Killog.Util

  @impl true
  def mount(_params, _session, socket) do
    factions = Faction.factions()
    {:ok, assign(socket,
      faction: factions |> List.first(),
      factions: factions,
    )}
  end

  @impl true
  def handle_event("add", %{"name" => name, "faction" => faction_id} = input, socket) do
    clean_input = input
    |> Map.put("faction", Faction.select(faction_id).id)
    |> Util.value_inputs_to_numbers()

    case Roster.create(clean_input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
    end
  end
end
