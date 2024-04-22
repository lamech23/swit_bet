defmodule SwiftBetWeb.Games.GameLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Games
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  def mount(_params, _session, socket) do
    changeset = Games.change_games(%Games{})

    socket = assign(socket, :form, to_form(changeset))


    super_user = socket.assigns.current_user.role.role_permisions
    |> Enum.map(fn item ->
      item.permission.name 
    end)
    |> Enum.any?(fn item ->  
      item === "super-user"
    end)

    {:ok, assign(socket, super_user: super_user)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  def handle_event("save_game", games_params, socket) do
    save_game(socket, socket.assigns.live_action, games_params)

  end

  defp save_game(socket, :new,   %{"games" => games_params }) do
    case Games.create(games_params) do
      {:ok, games} ->
        socket =
          socket
          |> put_flash(:info, "game added succesfully ")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  # validate 
  def handle_event("validate", games_params, socket) do
    changeset =
      socket.assigns.games
      |> Games.changeset(games_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset: changeset)}
  end

  defp save_game(socket, :edit, %{"games" => games_params }) do
    game = socket.assigns.game


    case Games.update(game, games_params) do
      {:ok, _game} ->
        socket =
          socket
          |> put_flash(:info, " game updated")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All Games ")
  end

  defp apply_action(socket, :new, _params) do
    changeset = Games.change_games(%Games{})

    socket
    |> assign(:page_title, "Create New Game")
    |> assign(:game, %Games{})
    |> assign(:changeset, changeset)
    |> assign(:desc_title, "Create ")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    game = Games.get_game!(id)
    changeset = Games.change_games(game)

    socket
    |> assign(:page_title, "Update  ")
    |> assign(:desc_title, "Update  Game ")
    |> assign(:game, game)
    |> assign(:changeset, changeset)
  end


  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end
end
