defmodule SwiftBetWeb.BetSlip.BetHistoryLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center  ">
      <h2 class="text-3xl   font-semibold mb-4">Bet Slip - SwiftBet</h2>
      <h2 class="text-3xl text-green-600  font-semibold mb-4 "><%= @status.status %></h2>
      <div class="flex flex-col gap-8 w-1/2   ">
        <%= for bet <- @slip_list do %>
          <div class=" flex flex-row justify-between  item-center  border w-full p-10 shadow-md shadow-indigo-100 ">
            <div>
              <p class="text-2xl mb-4  text-gray-600">Teams</p>
              <p class="font-semibold text-3xl capitalize"><%= bet.teams %></p>
            </div>
            <div>
              <p class="text-2xl mb-4  text-gray-600">Odd</p>

              <p class="text-gray-500 text-2xl"><%= bet.odds %></p>
            </div>

            <div>
              <p class="text-2xl mb-4  text-gray-600">Pick</p>

              <p class="text-2xl text-teal-500"><%= bet.selected %></p>
            </div>
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

  def handle_params(%{"id" => id}, _uri, socket) do
    slip_list = Bets.get_user_bets(id)

    bet_status =
      slip_list
      |> Enum.at(1)

    bet_ids = slip_list |> Enum.map(& &1.id)

    {:noreply, assign(socket, slip_list: slip_list, bet_ids: bet_ids, status: bet_status)}
  end

  def handle_event("bet_cancel", %{"bets" => bets}, socket) do
    bets
    |> Bets.cancel_bet()

    {:noreply,
     socket
     |> put_flash(:info, "Bet canceld ")}
  end
end
