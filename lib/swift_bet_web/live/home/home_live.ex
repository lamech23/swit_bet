defmodule SwiftBetWeb.Home.HomeLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Games
  alias SwiftBet.Bets
  alias SwiftBet.Repo
  alias SwiftBet.Placed
  alias SwiftBet.Accounts

  def mount(_params, _session, socket) do
    changeset = Games.change_games(%Games{})
    socket = assign(socket, :form, to_form(changeset))


    all_games = Games.list_games()
    selected_items = [] 
    total_odds = 0.0
    stake = Map.get(socket.assigns, :stake, 100) |> Integer.to_string() |> IO.inspect()

    {:ok,
     assign(socket,
       games: all_games,
       selected_items: selected_items,
       total_odds: total_odds,
       stake: stake
     )}
  end

  def handle_event("place_slip", %{"home" => home_id, "odd" => odd, "selection" => selection}, socket) do
    home_id = String.to_integer(home_id)
    odds = String.to_float(odd)

    item = socket.assigns.games |> Enum.find(&(&1.id == home_id)) 


    game_odds = socket.assigns.games |> Enum.find(&(&1.id == odds))

    if Enum.any?(socket.assigns.selected_items, &(&1.id == home_id)) do
      {:noreply, 
      socket = 
      socket 
      |> put_flash(:error,  "odd  already selected")

    }
    {:noreply, socket}

    else
      # Checking if the :odds key is present in the selected item, if not, initialize it with an empty map
      item = Map.update(item, :odds, [], & &1)

      # Add the odds to the selected item
      item_with_odds = %{item | odds: Enum.join([odd | item.odds], ",")}

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

      stakes = Map.get(socket.assigns, :stake, 0)
      %{current_user: user} = socket.assigns

      selected_fields =
        Enum.map(new_selected_items, fn game ->
          %{
            away: game.away,
            day: game.day,
            draw: game.draw,
            home: game.home,
            odds: game.odds,
            teams: game.teams,
            time: game.time,
            user_id: user.id,
            selected:  selection,
          }
        end)
        

      selected_fields_with_stake =
        Enum.map(selected_fields, fn field ->
          stake = Map.get(field, :stake, stakes)
          user_id = Map.get(field, :user_id, user.id)
          Map.put(field, :stake, stake)
          Map.put(field, :selection, stake)
          Map.put(field, :total_payout, Float.to_string(Float.round(odds_list * String.to_integer(stake), 2)))

        end)


      socket =
        socket
        |> assign(
          selected_items: new_selected_items,
          total_odds: odds_list,
          bets: selected_fields_with_stake
        )

      {:noreply, socket}
    end
  end

  def handle_event("remove_slip", %{"home_id" => home_id}, socket) do
    home_id = String.to_integer(home_id)

    new_selected_items =
      socket.assigns.selected_items
      |> Enum.filter(fn item -> item.id != home_id end)

    socket = assign(socket, selected_items: new_selected_items)

    {:noreply, socket}
  end

  def handle_event("save_bets", _params, socket) do
    bets = socket.assigns.bets

    case add_slip(bets) do
      bets when is_list(bets) ->
        user_id = Enum.at(bets, 0).user_id
        Enum.each(bets, fn bet ->
        case Placed.create(%{user_id: user_id, bet_id: bet.id}) do
          {:ok, slip_id} ->
            Enum.map(bets, fn bet ->
              bet
              |> Bets.update_slip_id(slip_id.id)
            end)
        end
      end)

        socket =
          socket
          |> put_flash(:info, "Bets placed")

        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> put_flash(:error, "Failed to place bets: #{reason}")

        {:noreply, socket}
    end
  end

  defp add_slip(bets) do
    bets
    |> Enum.map(fn bet_params ->
      %Bets{}
      |> Bets.change_bets(bet_params)
      |> Repo.insert!()
    end)
  end

  def handle_event("stake", %{"stake" => stake}, socket) do
    added_stake =
      stake

    {:noreply, assign(socket, stake: added_stake)}
  end
end
