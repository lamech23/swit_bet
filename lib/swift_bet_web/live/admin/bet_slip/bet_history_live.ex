defmodule SwiftBetWeb.BetSlip.BetHistoryLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Bets

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify- items-center   ">

    <div class= "flex flex-col  justify-end items-start " >
      <h2 class="text-3xl   font-semibold mb-4">Bet Slip - SwiftBet</h2>

      <%= if @status.status == "cancelled" do %>
        <h2 class="text-3xl text-red-600  font-semibold mb-4 "><%= @status.status %></h2>
      <% else %>
        <h2 class="text-3xl text-green-600  font-semibold mb-4 "><%= @status.status %></h2>
      <% end %>

    </div>

      <div class="flex flex-col gap-8 w-1/2   ">
        <%= for bet <- @slip_list do %>
          <div class="flex flex-col md:flex-row divide-solid divide-slate-300 justify-between items-center  w-full p-10 shadow-sm  shadow-indigo-100 rounded-lg bg-gray-200  ">



            <div>
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Teams</p> 
              <div class=" flex justify-center items-center   gap-2 mb-6 md:mb-0 ">
            <img 
            
            src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAAC8UlEQVR4nO2ZTUgVURTHf/aKhAgr4wU9iAjpgxbZKsp2BRFlBC4kKoLsCyIUCkpsFS6iaFEUJVELbREtKowgiCjpLcqiFtFGEzQw4rUIq0W9tBcXzsBFZsaZufNm5j3mD2fxrvfMPb+5X+eMkCpVqlQ2agCOAveAb8AjoMauo7TfB74AD4B2YD0wixg0F2gFbgGjQMnGOh18uxz6fwf6BWxxFBCtwGeHYKbbdSArfkuAGx79fgFngUw5ADJAj8dA7N52EL9nwLywQS4FDMbU+sKE2ABMxQSibHMYEOo0eR0jhLJXLqegZx2OGcKyZhOIhUAhARAl4IPJKXY1AQC6HZC4GoE9wGwvEOuAyQQEr9uoXMZq374HxoCTwHw3kBeGg6qXcBvYB+wHuiUtMYXpkPhatLaC/LbVuMFg6mZusnmmutwGDUHGtf07/W+n7EBUSnEemAgw2DVtMLVJP8qSQNZ5UIgp4Io8Z6VDn71OM1MHnAG++hjwmPju1NrWSFtTwGV6R3sGkrDa9VVx1uKiWglwyMPAI8Bb4JP8/gsskufs8gGg/HqBVVocy4G7M/ipE82TvAZSlDVtrV11Oz/06HtO6hxLDTILRQ++j8MGUYWTpYzPxNOSWk59Mjt+ZjIbJog66w9qb7ZGNqsfkKDJanuYIJb9BBaIb9YnSBAIZW/CALkpRZh+Z2zR/CciACkBq01BctLvuNa2XdrUzPyLCKTbFGSH9Fsm9f07LR9qjmhpleQaMAIZcCiE6uQAiAokbwqi7IkkjBuBbfIZaMxHEEFAisBzyUQavVSVJm8pTJAfwAnJ7XbPlM4nGWTQb+BJBemtFpCuagFpqRaQtdUAMqlVnRUNMkQIypcZ4qWMk3Pp008FqdMF5AIVoJxA/HEBaYsqmOEyL79NUYH8LjNIfVQgbbIhh8vwDblATJoDrJCi6rSUwXmp5YOADJBALQW2AkeAy8BTqezcQHqoINXL59VDwEX56DYis2j036tUqTDXf9dsvhMXH4l2AAAAAElFTkSuQmCC"
            class="bg-green-400 w-10 h-10 rounded-full  object-cover" 
            >
              <p class="text-lg md:text-lg text-gray-500 capitalize"><%= bet.teams %></p>
            </div>
              </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Home</p>
              <p class="text-lg md:text-lg text-gray-500"><%= bet.home %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Draw</p>
              <p class="text-lg md:text-lg text-gray-500"><%= bet.draw %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Away</p>
              <p class="text-lg md:text-lg text-gray-500"><%= bet.away %></p>
            </div>
            <div class="mb-6 md:mb-0">
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Selected</p>
              <p class="text-lg md:text-lg text-gray-500"><%= bet.selected %></p>
            </div>
            <div>
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Odd</p>
              <p class="text-lg md:text-lg text-gray-500"><%= bet.odds %></p>
            </div>
            <div>
              <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2 capitalize">out-come </p>
              <p class="whitespace-nowrap rounded-full bg-green-100 w-1/2 px-3.5 py-0.5 text-sm text-green-700  ">1-0</p>
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
    id |>  IO.inspect()
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
