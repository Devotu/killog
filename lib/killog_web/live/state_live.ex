defmodule KillogWeb.StateNewLive do
  use KillogWeb, :live_view

  alias Killog.Data
  alias Killog.Util

  @impl true
  def render(assigns) do
    ~L"""
    <section class="plaque v-fill">
      <p class="alert alert-warning"><%= live_flash(@flash, :rerun_error) %></p>
      <p class="alert alert-success"><%= live_flash(@flash, :rerun_ok) %></p>
      <pre><%= Util.struct_to_pretty(@state) %></pre>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    state = params["id"]
    |> Data.recall_state()
    {:ok, assign(socket, state: state, confirm: false)}
  end
end
