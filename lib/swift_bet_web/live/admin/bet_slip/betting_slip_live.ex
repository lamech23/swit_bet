defmodule SwiftBetWeb.BetSlip.BettingSlipLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo
  alias SwiftBet.Placed

  def render(assigns) do
    ~H"""
<section class="flex flex-col gap-6 justify-center items-center">
  <%= for {slip, index} <- Enum.with_index(@slips) do %>
    <div class="flex flex-row justify-between items-start border rounded-lg bg-gray-100 hover:bg-gray-300 shadow-xl shadow-indigo-100 w-1/2 h-60">
      <div class="m-10 flex flex-col gap-4">
        <.link
          navigate={~p"/user/bet-history/#{slip.slip_id}"}
          phx-click="slip_id"
          phx-value-id={slip.slip_id}
          class="text-2xl text-gray-400"
        >
          # <%= "#{index + 1}#{slip.random_string}" %>
        </.link>

        <div class="flex flex-row gap-2">
          <p class="font-bold text-2xl text-gray-600">Stake -</p>

          <.link
            navigate={~p"/user/bet-history/#{slip.slip_id}"}
            phx-click="slip_id"
            phx-value-id={slip.slip_id}
            class="font-bold text-2xl text-gray-600"
          >
            KSH <%= slip.stake %>
          </.link>
        </div>

        <.link
          navigate={~p"/user/bet-history/#{slip.slip_id}"}
          phx-click="slip_id"
          phx-value-id={slip.slip_id}
          class="font-bold text-3xl text-gray-600"
        >
          <%= slip.relative_time %>
        </.link>

        <div class="flex items-center gap-2">
          <p class="font-bold capitalize text-2xl text-gray-600">Status -</p>
          <%= if slip.status == "cancelled" do %>
            <span class="font-bold text-lg text-red-600">
              <%= slip.status %>
            </span>
          <% else %>
            <span class="font-bold text-lg text-teal-600">
              <%= slip.status %>
            </span>
          <% end %>
        </div>
      </div>

      <div class="m-10 flex flex-col gap-4">
        <span class="flex flex-row gap-2 font-bold text-2xl text-gray-600 capitalize">
          <span>Possible Win -</span>
          <p>KSH</p>
          <p><%= slip.total_payout %></p>
        </span>
      </div>
    </div>
  <% end %>
</section>

    """
  end

  def mount(_session, _params, socket) do
    %{current_user: user} = socket.assigns

    bets = Bets.get_user_bets(user.id)

    random_string =
      :crypto.strong_rand_bytes(2)
      |> Base.encode16()
      |> IO.inspect()

    bet_ids = bets |> Enum.map(& &1.id)

    slips =
      Placed.get_slips(user.id)
      |> Enum.uniq(& &1.bet.slip_id)

    times =
      slips
      |> Enum.map(fn item ->
        case Timex.format(item.bet.time, "{YYYY}-{0M}-{D}") do
          {:ok, time} ->
            Map.put(item.bet, :relative_time, time)
        end
      end)

    random =
      times
      |> Enum.map(fn item ->
        item |> Map.put(:random_string, random_string)
      end)
      |> IO.inspect()

    {:ok, assign(socket, bets: bets, bet_ids: bet_ids, slips: random)}
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
