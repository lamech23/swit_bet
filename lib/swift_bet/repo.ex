defmodule SwiftBet.Repo do
  use Ecto.Repo,
    otp_app: :swift_bet,
    adapter: Ecto.Adapters.Postgres
end
