defmodule SwiftBet.Worker do
  alias SwiftBet.Games
  alias SwiftBet.Repo
  alias SwiftBet.Mailer
  alias SwiftBet.Accounts.{User, UserNotifier}

  require Logger

  use Oban.Worker,
    queue: :events

  @impl Oban.Worker
  def perform(_) do

    games = Games.change_bet_status_to_lose()



 
  end
end
