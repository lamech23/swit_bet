defmodule SwiftBet.Repo.Migrations.CreateStaks do
  use Ecto.Migration

  def change do
    create table(:stakes) do
      add :name, :integer, default: 0
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
