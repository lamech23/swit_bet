defmodule SwiftBet.Worker do

  alias SwiftBet.Games


  use Oban.Worker, queue: :events

  def perform() do
   Games.change_bet_status_to_lose()
  end
end
