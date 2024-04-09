defmodule SwiftBetWeb.Home.HomeLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Games
  alias SwiftBet.Bets
  alias SwiftBet.Repo

  def mount(_params, _session, socket) do
    all_games = Games.list_games()
    selected_items = []
    total_odds = 0.0

    {:ok,
     assign(socket, games: all_games, selected_items: selected_items, total_odds: total_odds)}
  end

  def handle_event("place_slip", %{"home" => home_id, "odd" => odd}, socket) do
    home_id = String.to_integer(home_id)
    odds = String.to_float(odd)

    item = socket.assigns.games |> Enum.find(&(&1.id == home_id))
    game_odds = socket.assigns.games |> Enum.find(&(&1.id == odds))

    if Enum.any?(socket.assigns.selected_items, &(&1.id == home_id)) do
      {:noreply, assign(socket, put_flash: %{error: "Item already selected"})}
    else
      # Check if the :odds key is present in the selected item, if not, initialize it with an empty map
      item = Map.update(item, :odds, [], & &1)

      # Add the odds to the selected item
      item_with_odds = %{item | odds: [odd | item.odds]}

      # Retrieve the list of selected items from the socket assigns or initialize it if it doesn't exist

      selected_items = Map.get(socket.assigns, :selected_items)

      # Append the selected item with odds to the list of selected items
      new_selected_items = [item_with_odds | selected_items]

      odds_list =
        Enum.map(new_selected_items, & &1.odds)
        |> List.flatten()
        |> Enum.map(&String.to_float/1)
        |> case do
          [] -> 0.0
          [first | rest] -> Enum.reduce(rest, first, &(&1 + &2))
        end

      selected_fields =
        Enum.map(new_selected_items, fn game ->
          %{
            away: game.away,
            day: game.day,
            draw: game.draw,
            home: game.home,
            odds: game.odds,
            teams: game.teams,
            time: game.time
          }
        end)

      socket =
        socket
        |> assign(selected_items: new_selected_items, total_odds: odds_list, bets:  selected_fields)

      {:noreply, socket}
    end
  end

  def handle_event("remove_slip", %{"home_id" => home_id}, socket) do
    home_id = String.to_integer(home_id)

    new_selected_items =
      socket.assigns.selected_items
      |> Enum.filter(fn item -> item.id != home_id end)

    new_socket = assign(socket, selected_items: new_selected_items)

    {:noreply, new_socket}
  end

  def handle_event("save_bets", _params, socket) do

    bets = 
      socket.assigns.bets 
      |> IO.inspect()

    case add_slip(bets) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "Bet placed")
        |> push_event("refresh_selected_items", %{})
  
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
  
  defp get_slected_games(games)do
    games
  # |> IO.inspect()

    
  end
  

  defp add_slip(bets) do
    bets
   |>  Enum.each( fn bet_params ->
      %SwiftBet.Bets{}
      |> SwiftBet.Games.changeset(bet_params)
      |> Repo.insert()
    end)
  end
end
