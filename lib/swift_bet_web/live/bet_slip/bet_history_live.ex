defmodule SwiftBetWeb.BetSlip.BetHistoryLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets


  def render(assigns) do
    ~H"""
    <div class="bg-gray-100 rounded-lg shadow-md p-6">
      <h2 class="text-lg font-semibold mb-4">Bet Slip - SwiftBet</h2>
      <div class="grid grid-cols-2 gap-4">
        <%= for bet <- @slip_list do %>
          <div>
            <p class="text-sm text-gray-600">Home</p>
            <p class="font-semibold"><%= bet.teams %></p>
            <p class="text-lg text-gray-500"><%= bet.odds %></p>
            <p class="text-lg text-gray-500"><%= bet.status %></p>
          </div>
        <% end %>
      </div>
      <div class="mt-4">
        <button
          class="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          phx-click={JS.push("bet_cancel", value: %{"bets" => @bet_ids})}
          data-confirm="Are you sure?"
        >
          cancel
        </button>
      </div>
    </div>
    """
  end

  def mount(_sessions, _params, socket) do

    

    {:ok, socket}
  end


  def handle_params(%{"id"=> id}, _uri, socket) do

    slip_list = Bets.get_user_bets(id)
    bet_ids = slip_list |> Enum.map(& &1.id)


    |> IO.inspect()

    {:noreply, assign(socket, slip_list: slip_list, bet_ids: bet_ids)}
  end


  def handle_event("bet_cancel", %{"bets" => bets}, socket) do
    bets
    |> Bets.cancel_bet()

    {:noreply,
     socket
     |> put_flash(:info, "Bet canceld ")}
  end


end
