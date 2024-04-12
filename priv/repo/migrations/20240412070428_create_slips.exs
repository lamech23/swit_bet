defmodule SwiftBet.Repo.Migrations.CreateSlips do
  use Ecto.Migration

  def change do
    create table(:slips) do
      add :bet_id, :integer
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
