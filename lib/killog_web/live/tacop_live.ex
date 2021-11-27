defmodule KillogWeb.TacopLive do
  use KillogWeb, :live_view

  alias Killog.Modules.Tacop

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, archetypes: Tacop.archetypes)}
  end

  @impl true
  def handle_event("add", %{"name" => name, "archetype" => _archetype} = input, socket) do
    case Tacop.create(input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
    end
  end
end
