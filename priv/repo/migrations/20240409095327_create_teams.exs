defmodule SwiftBet.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :home, :string
      add :draw, :string
      add :away, :string
      add :teams, :string
      add :day, :date
      add :odds, {:array, :string}
      add :time, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
