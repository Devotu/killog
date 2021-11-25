defmodule KillogWeb.PlayerLive do
  use KillogWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, attack: 0, results: [])}
  end

  @impl true
  def handle_event("add", %{"name" => name}, socket) do
    {:noreply, put_flash(socket, :feedback, "#{name} added")}
  end
end
