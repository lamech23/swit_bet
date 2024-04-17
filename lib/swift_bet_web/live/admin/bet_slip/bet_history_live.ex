defmodule SwiftBetWeb.BetSlip.BetHistoryLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center  ">
      <h2 class="text-3xl   font-semibold mb-4">Bet Slip - SwiftBet</h2>

      <%= if @status.status == "cancelled" do %>
        <h2 class="text-3xl text-red-600  font-semibold mb-4 "><%= @status.status %></h2>
      <% else %>
        <h2 class="text-3xl text-green-600  font-semibold mb-4 "><%= @status.status %></h2>
      <% end %>
      <div class="flex flex-col gap-8 w-1/2   ">
        <%= for bet <- @slip_list do %>
          <div class="flex flex-col md:flex-row justify-between items-center border w-full p-10 shadow-md shadow-indigo-100 rounded-lg bg-white">
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Teams</p>
              <p class="text-lg md:text-lg text-teal-500 capitalize"><%= bet.teams %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Home</p>
              <p class="text-lg md:text-lg text-teal-500"><%= bet.home %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Draw</p>
              <p class="text-lg md:text-lg text-teal-500"><%= bet.draw %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Away</p>
              <p class="text-lg md:text-lg text-teal-500"><%= bet.away %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Selected</p>
              <p class="text-lg md:text-lg text-teal-500"><%= bet.selected %></p>
            </div>
            <div>
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Odd</p>
              <p class="text-lg md:text-lg text-teal-500"><%= bet.odds %></p>
            </div>
          </div>
        <% end %>
      </div>
      <%= if  @status.status == "cancelled" || @status.status == "lose" || @status.status == "win"  do %>
      <% else %>
        <div class="mt-4">
          <button
            class="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            phx-click={JS.push("bet_cancel", value: %{"bets" => @bet_ids})}
            data-confirm="Are you sure?"
          >
            cancel
          </button>
        </div>
      <% end %>
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
      |> IO.inspect()

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
