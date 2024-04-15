defmodule SwiftBetWeb.BetSlip.SpecificUserBetsLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Placed
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center  ">
      <div class="flex flex-col gap-8 w-1/2   ">
        <%= for item <- @bets do %>
          <div class=" flex flex-row justify-between  item-center  border w-full p-10 shadow-md shadow-indigo-100 ">
            
            <div>
            <p class="text-2xl mb-4  text-gray-600">Teams </p>
            <p class="font-semibold text-3xl capitalize"><%= item.bet.teams  %></p>
            </div>
            <div>
            <p class="text-2xl mb-4  text-gray-600">Odd</p>

            <p class="text-gray-500 text-2xl"><%= item.bet.odds %></p>

            </div>

            <div>
            <p class="text-2xl mb-4  text-gray-600">Pick</p>

            <p class="text-2xl text-teal-500"><%= item.bet.selected  %></p>

            </div>
          </div>
        <% end %>
      </div>
 
    </div>
    """
  end

  def mount(_session, _params, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    id |> String.to_integer()

    bets = Placed.all_slips(id)

    {:noreply, assign(socket, bets: bets)}
  end
end
