defmodule KillogWeb.ListLive do
  use KillogWeb, :live_view

  alias Killog.Data
  alias Killog.Id

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <table>
        <tr class="v-list header">
          <td class="statelist label">
            <span class="v-list-item">Type</span>
          </td>
          <td class="statelist label">
            <span class="v-list-item">Name</span>
          </td>
          <td class="statelist label">
            <span class="v-list-item">Id</span>
          </td>
          <td class="statelist label">
            <span class="v-list-item">Link</span>
          </td>
        </tr>
        <%= for state <- @states do %>
        <tr class="v-list">
          <td class="statelist clicksize">
            <span class="v-list-item"><%= state.id |> Id.extract_type() |> String.capitalize() %></span>
          </td>
          <td class="statelist clicksize">
            <span class="v-list-item"><%= state.name %></span>
          </td>
          <td class="statelist clicksize">
            <span class="v-list-item"><%= state.id %></span>
          </td>
          <td class="statelist clicksize">
            <%= link(state.name, method: :get, to: "/#{state.id}/state", class: "v-list-item cut")%>
          </td>
        </tr>
        <% end %>
      </table>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    states = Data.list_ids(:equipment)
    ++ Data.list_ids(:fireteam)
    ++ Data.list_ids(:player)
    ++ Data.list_ids(:tacop)
    ++ Data.list_ids(:weapon)
    ++ Data.list_ids(:roster)
    |> Data.recall_state()

    {:ok, assign(socket, states: states, confirm: false)}
  end
end
