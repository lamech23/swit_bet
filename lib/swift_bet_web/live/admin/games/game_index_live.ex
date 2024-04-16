defmodule SwiftBetWeb.Games.GameIndexLive do
  use SwiftBetWeb, :live_view
  alias  SwiftBet.Games
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}


  def mount(_params, _session, socket) do

    all_games = Games.list_games()

      {:ok, assign(socket, games: all_games)}
    end

    

  def handle_event("delete_game", %{"id" => id}, socket) do
    game = Games.get_game!(id)
    Games.delete_game(game)

    {:noreply,
    socket =
     socket
     |> put_flash(:info, "Game  deleted successfully")}
  end


end
