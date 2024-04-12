defmodule SwiftBetWeb.BetSlip.BettingSlipLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo
  alias SwiftBet.Placed

  def render(assigns) do
    ~H"""
    <section>
      <%= for {slip, index} <- Enum.with_index(@slips) do %>
        <.link
          navigate={~p"/root/bet-history/#{slip.id}"}
          phx-click="slip_id"
          phx-value-id={slip.id}
          class="text-white bg-gradient-to-r from-green-400 via-green-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
        >
          <%= "Bet Slip #{index + 1}" %>
        </.link>
      <% end %>
    </section>
    
    """
  end

  def mount(_session, _params, socket) do
    %{current_user: user} = socket.assigns

    bets = Bets.get_user_bets(user.id)

    bet_ids = bets |> Enum.map(& &1.id)

    slips = Placed.get_slips()

    {:ok, assign(socket, bets: bets, bet_ids: bet_ids, slips: slips)}
  end


  def handle_event("slip_id", %{"id" => id}, socket) do
    bet_slips =
      id
      |> String.to_integer()
      |> Bets.get_user_bets()

    {:noreply,
    socket 
    |> redirect(to: "/root/root/bet-history/#{id}")
   }
    
  end
end
