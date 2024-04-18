defmodule SwiftBet.Repo.Migrations.CreatePermisionsIds do
  use Ecto.Migration

  def change do
    create table(:permisions_ids) do

      add :role_id, :integer
      add :permission_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
