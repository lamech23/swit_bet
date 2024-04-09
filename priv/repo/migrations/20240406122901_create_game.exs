defmodule SwiftBet.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :teams, :string
      add :home, :string
      add :draw, :string
      add :away, :string
      add :time, :utc_datetime
      add :day, :date
      add :user_id, references(:users)


      timestamps(type: :utc_datetime)
    end
  end
end
