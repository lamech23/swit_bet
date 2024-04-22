defmodule SwiftBet.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :home, :string
      add :draw, :string
      add :away, :string
      add :teams, :string
      add :day, :date
      add :stake, :string
      add :odds, :string
      add :slip_id, :integer
      add :total_payout, :string
      add :selected, :string
      add :status, :string, default: "open"
      add :home_out_come, :integer, default: 0
      add :away_out_come, :integer, default: 0
      add :time, :utc_datetime
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end
