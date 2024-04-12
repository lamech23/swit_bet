defmodule SwiftBetWeb.BetSlip.BettingSlipLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo

  def render(assigns) do
    ~H"""
    <div class="bg-gray-100 rounded-lg shadow-md p-6">
      <h2 class="text-lg font-semibold mb-4">Bet Slip - SwiftBet</h2>
      <div class="grid grid-cols-2 gap-4">
        <%= for bet <- @bets do %>
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

  def mount(_session, _params, socket) do
    %{current_user: user} = socket.assigns
    user |> IO.inspect

    bets = Bets.get_user_bets(user.id)

    bet_ids = bets |> Enum.map(& &1.id)

    {:ok, assign(socket, bets: bets, bet_ids: bet_ids)}
  end

  def handle_event("bet_cancel", %{"bets" => bets}, socket) do
    bets
    |> Bets.cancel_bet()

    {:noreply,
     socket
     |> put_flash(:info, "Bet canceld ")}
  end
end
