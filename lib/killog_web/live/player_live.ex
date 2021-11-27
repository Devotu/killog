defmodule KillogWeb.PlayerLive do
  use KillogWeb, :live_view

  alias Killog.Id
  alias Killog.Modules.Player

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, attack: 0, results: [])}
  end

  @impl true
  def handle_event("add", %{"name" => name} = input, socket) do
    case Player.create(input) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{name} not added,  #{e}")}
      {:ok} ->
        {:noreply, put_flash(socket, :feedback, "#{name} added")}
      _ ->
        {:noreply, put_flash(socket, :error, "#{name} not added")}
    end
  end
end
