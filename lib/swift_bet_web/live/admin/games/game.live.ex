defmodule SwiftBetWeb.Games.GameLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Games
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}


  def mount(_params, _session, socket) do
    changeset = Games.change_games(%Games{})

    socket = assign(socket, :form, to_form(changeset))

    {:ok, socket}
  end

  def handle_event("save_game", games_params, socket) do
    case Games.create(games_params) do
      {:ok, games} ->
        socket =
          socket
          |> put_flash(:info, "game added succesfully ")

        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  # validate 
  def handle_event("validate", games_params, socket) do
    changeset =
      socket.assigns.games
      |> Games.changeset(games_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset: changeset )}
  end

   

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end


end
