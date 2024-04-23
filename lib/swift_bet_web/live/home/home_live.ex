defmodule SwiftBetWeb.Home.HomeLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Games
  alias SwiftBet.Bets
  alias SwiftBet.Repo
  alias SwiftBet.Placed
  alias SwiftBet.Accounts
  alias SwiftBet.Stake
  alias SwiftBet.Accounts.User
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :nav}


  def mount(_params, _session, socket) do
    changeset = Games.change_games(%Games{})
    socket = assign(socket, :form, to_form(changeset))

    user = socket.assigns.current_user  
    deposits =
    Stake.deposit(user.id)
    |> case do
      nil -> 0
     0
     _ -> 
        Stake.deposit(user.id) |> String.to_integer()
    end

    

    all_games =
      Games.list_games()
      |> Enum.map(fn item ->
        case Timex.format(item.time, "{Mshort} {0M} {YYYY} {D} at {h12}:{m}") do
          {:ok, time} ->
            Map.put(item, :relative_time, time)
        end
      end)

    selected_items = []
    total_odds = 0.0
    stake = Map.get(socket.assigns, :stake, 0) |> Integer.to_string()

    revenue =
      Games.check_won(user.id)
      |> Enum.map(&String.to_float(&1.total_payout))
      |> Enum.sum()

    Games.get_winning_bet_stake(user.id)

  user_stake=   Bets.get_bets_for_user(user.id) 




    {:ok,
     assign(socket,
       games: all_games,
       selected_items: selected_items,
       total_odds: total_odds,
       stake: stake,
       revenue: revenue,
       deposits: deposits,
       stakes_for_user: user_stake

     )}
  end

  def handle_event(
        "place_slip",
        %{"home" => home_id, "odd" => odd, "selection" => selection},
        socket
      ) do
    home_id = String.to_integer(home_id)
    odds = String.to_float(odd)

    stake = socket.assigns.stake

    item = socket.assigns.games |> Enum.find(&(&1.id == home_id))

    game_odds = socket.assigns.games |> Enum.find(&(&1.id == odds))

    if Enum.any?(socket.assigns.selected_items, &(&1.id == home_id)) do
      selected_items =
        socket.assigns.selected_items
        |> Enum.map(fn item ->
          if item.id == home_id, do: %{item | selected: selection}, else: item
        end)
        |> Enum.map(fn item ->
          if item.id == home_id, do: %{item | selected: selection}, else: item
        end)

      {:noreply, assign(socket, selected_items: selected_items)}
    else
      # Checking if the :odds key is present in the selected item, if not, initialize it with an empty map
      item = Map.update(item, :odds, [], & &1)

      # Add the odds to the selected item
      item_with_odds =
        %{item | odds: Enum.join([odd | item.odds], ",")}
        |> Map.put(:selected, selection)
        |> Map.put(:stake, stake)

      # Retrieve the list of selected items from the socket assigns or initialize it if it doesn't exist

      selected_items = Map.get(socket.assigns, :selected_items)
      |> IO.inspect()

      # Append the selected item with odds to the list of selected items
      new_selected_items = [item_with_odds | selected_items]
      # |> IO.inspect(label: "this nigger ")

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
            selected: game.selected
          }
        end)


       

      selected_fields_with_stake =
        Enum.map(selected_fields, fn field ->
          stake = Map.get(field, :stake, stakes)
          user_id = Map.get(field, :user_id, user.id)
          Map.put(field, :stake, stake)
          Map.put(field, :selected, selection)

          Map.put(
            field,
            :total_payout,
            Float.to_string(Float.round(odds_list * String.to_integer(stake), 2))
          )
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
    item_to_remove = Enum.find(socket.assigns.selected_items, &(&1.id == home_id))

    removed_item_odds = item_to_remove.odds
    total_odds = socket.assigns.total_odds
    new_total_odds = total_odds - String.to_float(removed_item_odds)

    new_selected_items =
      socket.assigns.selected_items
      |> Enum.filter(fn item -> item.id != home_id end)

    socket = assign(socket, selected_items: new_selected_items, total_odds: new_total_odds)

    {:noreply, socket}
  end

  def handle_event("save_bets", _params, socket) do
    items = socket.assigns.selected_items
    stake = socket.assigns.stake
    session = Map.put(socket.assigns, :stake, stake)
    user = socket.assigns.current_user


    odds_list = socket.assigns.total_odds

    bets =
      socket.assigns.bets
      |> Enum.map(fn item ->
        item
        |> Map.put(:stake, stake)
        |> Map.put(
          :total_payout,
          Float.to_string(Float.round(odds_list * String.to_integer(stake), 2))
        )
      end)

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


      #   deposit =socket.assigns.deposits  |>IO.inspect(label: "Deposits")
      #  stakes =  socket.assigns.stake |>String.to_integer() |>IO.inspect(label: "Stakes")
      # user_stake =  socket.assigns.stakes_for_user |>String.to_integer() |>IO.inspect(label: "User Stakes")

  

      # new_fig = deposit - stakes - user_stake 

      # # Ensure the result is not negative
      # new_fig = if new_fig < 0, do: 0, else: new_fig
      
      # # Convert new_fig to string
      # new_fig_str = Integer.to_string(new_fig)
      
      # # Log new_fig_str to verify its value
      # IO.inspect(new_fig_str, label: "new_fig_str")
      
      # # Update the stake
      # Stake.deposits(user.id)
      # |> Stake.update( %{name: new_fig_str})
      # |> IO.inspect()


        socket =
          socket
          |> put_flash(:info, "Bets placed")
          |> assign(selected_items: [])

        {:noreply, assign(socket, session: session)}

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
    added_stake = stake 

    if stake == 0 do
      {:noreply,
       socket =
         socket
         |> put_flash(:error, "please add an amount ")}

      {:noreply, socket}
    else
      {:noreply, assign(socket, stake: added_stake)}
    end
  end

  def handle_event("check_bet_slip", _params, socket) do
    user = socket.assigns.current_user

    bets = Placed.get_slips(user.id)

    case bets do
      [] ->
        socket =
          socket
          |> push_redirect(to: "/user/bet-slip")

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> push_redirect(to: "/user/bet-slip")

        {:noreply, socket}
    end
  end


  def handle_event("save_deposit", deposit_params, socket) do
    user = socket.assigns.current_user
    deposit_params_with_user_id =
    deposit_params
    |> Map.put("user_id", user.id)
    |> IO.inspect

    case Stake.create(deposit_params_with_user_id) do
      {:ok, _deposit} ->
        socket =
          socket
          |> put_flash(:info, "Deposited")

        {:noreply, socket}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset)}
    end
  end


end
