defmodule SwiftBetWeb.BetSlip.BettingSlipLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo
  alias SwiftBet.Placed

  def render(assigns) do
    ~H"""
    <section class="flex  flex-col gap-6  justify-center  items-center ">
      <%= for {slip, index} <- Enum.with_index(@slips) do %>
      
      <div class="flex flex-row justify-between  items-start  border rounded-lg bg-gray-100 hover:bg-gray-300 shadow-xl shadow-indigo-100  w-1/2  h-60  ">
      <div class="m-10">
      <%= if slip.bet == nil do %>
      <% else %>
        <.link
          navigate={~p"/root/bet-history/#{slip.id}"}
          phx-click="slip_id"
          phx-value-id={slip.id}
          class="font-bold text-3xl text-gray-600"
        >
          <%= " #{slip.bet.time}" %>
        </.link>
        <% end %>

        </div>
        <div class="m-10">

        <%= if slip.bet == nil do %>
        <% else %>
        <div class="flex flex-col gap-4 ">
       
        <span class=" flex flex-row  gap-2  font-bold text-3xl text-gray-600">
        <p>
        KSH
        </p>
        <p> 
        <%=  slip.bet.total_payout %>

        </p>

          </span>
          <span class="font-bold text-lg text-teal-600">
          <%= slip.bet.status %>

          </span>
          </div>

        <% end %>
        </div>
        </div>

      <% end %>
    </section>
    """
  end

  def mount(_session, _params, socket) do
    %{current_user: user} = socket.assigns
    user |> IO.inspect()

    bets = Bets.get_user_bets(user.id)

    bet_ids = bets |> Enum.map(& &1.id)

    slips = Placed.get_slips(user.id) |> IO.inspect()

    {:ok, assign(socket, bets: bets, bet_ids: bet_ids, slips: slips)}
  end

  def handle_event("slip_id", %{"id" => id}, socket) do
    bet_slips =
      id
      |> String.to_integer()
      |> Bets.get_user_bets()

    {:noreply,
     socket
     |> redirect(to: "/root/root/bet-history/#{id}")}
  end
end
