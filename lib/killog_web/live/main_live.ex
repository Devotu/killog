defmodule KillogWeb.MainLive do
  use KillogWeb, :live_view

  alias Dmage.Range.Calculator

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <table>
        <tr class="v-list">
          <td class="statelist clicksize">
            <%= link("equipment - new", method: :get, to: "/equipment/new", class: "v-list-item cut")%>
          </td>
        </tr>
        <tr class="v-list">
          <td class="statelist clicksize">
            <%= link("fireteam - new", method: :get, to: "/fireteam/new", class: "v-list-item cut")%>
          </td>
          </tr>
        <tr class="v-list">
        <td class="statelist clicksize">
            <%= link("player - new", method: :get, to: "/player/new", class: "v-list-item cut")%>
          </td>
          </tr>
        <tr class="v-list">
        <td class="statelist clicksize">
            <%= link("tacop - new", method: :get, to: "/tacop/new", class: "v-list-item cut")%>
          </td>
        </tr>
        <tr class="v-list">
          <td class="statelist clicksize">
            <%= link("unit - new", method: :get, to: "/unit/new", class: "v-list-item cut")%>
          </td>
        </tr>
        <tr class="v-list">
          <td class="statelist clicksize">
            <%= link("weapon - new", method: :get, to: "/weapon/new", class: "v-list-item cut")%>
          </td>
        </tr>
        <tr class="v-list">
          <td class="statelist clicksize">
            <%= link("list - all states", method: :get, to: "/list", class: "v-list-item cut")%>
          </td>
        </tr>
      </table>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end
end
