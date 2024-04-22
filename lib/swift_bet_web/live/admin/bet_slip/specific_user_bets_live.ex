defmodule SwiftBetWeb.BetSlip.SpecificUserBetsLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Placed
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center  ">
      <div class="flex flex-col gap-8 w-1/2   ">

      <%= if @bets == [] do  %>
      <div class="bg-gray-100 flex items-center justify-center h-screen">

      <div class="flex flex-col items-center justify-center">
      <h3 class="text-4xl font-bold text-gray-400 mb-4">No Bet History Found</h3>
    <a href="https://www.example.com">
    </a>
  </div>
  </div>
        <% else %>

        <div class="flex flex-col justify- items-center   ">



  <div class="flex flex-col gap-8 w-full  ">
    <%= for bet <- @bets do %>
      <div class="flex flex-col md:flex-row divide-solid divide-slate-300 justify-between items-center  w-full p-10 shadow-sm  shadow-indigo-100 rounded-lg bg-gray-200  ">

        <div>
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Teams</p> 
          <div class=" flex justify-center items-center   gap-2 mb-6 md:mb-0 ">
        <img 
        
        src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAAsTAAALEwEAmpwYAAAC8UlEQVR4nO2ZTUgVURTHf/aKhAgr4wU9iAjpgxbZKsp2BRFlBC4kKoLsCyIUCkpsFS6iaFEUJVELbREtKowgiCjpLcqiFtFGEzQw4rUIq0W9tBcXzsBFZsaZufNm5j3mD2fxrvfMPb+5X+eMkCpVqlQ2agCOAveAb8AjoMauo7TfB74AD4B2YD0wixg0F2gFbgGjQMnGOh18uxz6fwf6BWxxFBCtwGeHYKbbdSArfkuAGx79fgFngUw5ADJAj8dA7N52EL9nwLywQS4FDMbU+sKE2ABMxQSibHMYEOo0eR0jhLJXLqegZx2OGcKyZhOIhUAhARAl4IPJKXY1AQC6HZC4GoE9wGwvEOuAyQQEr9uoXMZq374HxoCTwHw3kBeGg6qXcBvYB+wHuiUtMYXpkPhatLaC/LbVuMFg6mZusnmmutwGDUHGtf07/W+n7EBUSnEemAgw2DVtMLVJP8qSQNZ5UIgp4Io8Z6VDn71OM1MHnAG++hjwmPju1NrWSFtTwGV6R3sGkrDa9VVx1uKiWglwyMPAI8Bb4JP8/gsskufs8gGg/HqBVVocy4G7M/ipE82TvAZSlDVtrV11Oz/06HtO6hxLDTILRQ++j8MGUYWTpYzPxNOSWk59Mjt+ZjIbJog66w9qb7ZGNqsfkKDJanuYIJb9BBaIb9YnSBAIZW/CALkpRZh+Z2zR/CciACkBq01BctLvuNa2XdrUzPyLCKTbFGSH9Fsm9f07LR9qjmhpleQaMAIZcCiE6uQAiAokbwqi7IkkjBuBbfIZaMxHEEFAisBzyUQavVSVJm8pTJAfwAnJ7XbPlM4nGWTQb+BJBemtFpCuagFpqRaQtdUAMqlVnRUNMkQIypcZ4qWMk3Pp008FqdMF5AIVoJxA/HEBaYsqmOEyL79NUYH8LjNIfVQgbbIhh8vwDblATJoDrJCi6rSUwXmp5YOADJBALQW2AkeAy8BTqezcQHqoINXL59VDwEX56DYis2j036tUqTDXf9dsvhMXH4l2AAAAAElFTkSuQmCC"
        class="bg-green-400 w-10 h-10 rounded-full  object-cover" 
        >
          <p class="text-lg md:text-lg text-gray-500 capitalize"><%= bet.bet.teams %></p>
        </div>
          </div>
        <div class="mb-6 md:mb-0">
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Home</p>
          <p class="text-lg md:text-lg text-gray-500"><%= bet.bet.home %></p>
        </div>
        <div class="mb-6 md:mb-0">
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Draw</p>
          <p class="text-lg md:text-lg text-gray-500"><%= bet.bet.draw %></p>
        </div>
        <div class="mb-6 md:mb-0">
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Away</p>
          <p class="text-lg md:text-lg text-gray-500"><%= bet.bet.away %></p>
        </div>
        <div class="mb-6 md:mb-0">
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Selected</p>
          <p class="text-lg md:text-lg text-gray-500"><%= bet.bet.selected %></p>
        </div>
        <div>
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2">Odd</p>
          <p class="text-lg md:text-lg text-gray-500"><%= bet.bet.odds %></p>
        </div>
        <div>
          <p class="text-lg md:text-2xl font-semibold text-gray-800 mb-2 capitalize">results </p>
          <p class="whitespace-nowrap rounded-full bg-green-100 w-1/2 px-3.5 py-0.5 text-sm text-green-700  "><%= bet.bet.home_out_come %> - <%= bet.bet.away_out_come %></p>
        </div>
      </div>
    <% end %>
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
    |> IO.inspect()

    {:noreply, assign(socket, bets: bets)}
  end
end
