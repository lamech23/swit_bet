defmodule SwiftBet.Worker do

  alias SwiftBet.Games
require Logger
  use Oban.Worker,
    queue: :events

  @impl Oban.Worker
  def perform(_) do

    Logger.info("tets++++++")
  games =  Games.change_bet_status_to_lose() 
   Logger.info(games)

   
  end
end
